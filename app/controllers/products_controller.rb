class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Rails.cache.fetch("products/#{filter_params_cache_key}", expires_in: 1.hour) do
      products = Product.active.includes(:category)
      products = apply_filters(products)
      products.page(params[:page]).per(24)
    end

    @categories = Rails.cache.fetch("categories", expires_in: 12.hours) do
      Category.active.ordered
    end

    @brands = Rails.cache.fetch("brands", expires_in: 12.hours) do
      Product.distinct.pluck(:brand).compact
    end

    respond_to do |format|
      format.html
      format.json { render json: { products: products_json(@products) } }
    end
  end

  def show
    @related_products = Rails.cache.fetch("products/#{@product.id}/related", expires_in: 1.hour) do
      @product.category.products.active.where.not(id: @product.id).limit(4)
    end

    @reviews = Rails.cache.fetch("products/#{@product.id}/reviews/page/#{params[:page]}", expires_in: 1.hour) do
      @product.reviews.approved.includes(:user).page(params[:page]).per(5)
    end

    fresh_when etag: @product, last_modified: @product.updated_at, public: true
  end

  def search
    @query = params[:q].to_s.strip
    @products = Rails.cache.fetch("search/#{@query}/page/#{params[:page]}", expires_in: 15.minutes) do
      if @query.present?
        Product.includes(:category)
               .where("LOWER(name) LIKE :query OR LOWER(description) LIKE :query", query: "%#{@query.downcase}%")
               .active
               .ordered
               .page(params[:page])
               .per(12)
      else
        Product.none.page(params[:page])
      end
    end

    render :index
  end

  private

  def set_product
    @product = Product.active.find_by!(slug: params[:id])
  end

  def filter_params_cache_key
    [
      params[:category],
      params[:min_price],
      params[:max_price],
      params[:min_rating],
      params[:sort],
      params[:direction],
      params[:page]
    ].map(&:to_s).join('/')
  end

  def apply_filters(products)
    products = products.search(params[:query]) if params[:query].present?
    products = products.where(category_id: params[:category]) if params[:category].present?
    products = products.where('price >= ?', params[:min_price]) if params[:min_price].present?
    products = products.where('price <= ?', params[:max_price]) if params[:max_price].present?
    products = products.where('rating >= ?', params[:min_rating]) if params[:min_rating].present?
    products = products.order(sort_column => sort_direction)
    products
  end

  def sort_column
    %w[name price rating created_at].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def products_json(products)
    products.map do |product|
      Rails.cache.fetch("products/#{product.id}/json", expires_in: 1.hour) do
        {
          id: product.id,
          name: product.name,
          price: product.price,
          image_url: url_for(product.image),
          category: product.category.name,
          rating: product.rating,
          stock_status: product.in_stock? ? 'In Stock' : 'Out of Stock'
        }
      end
    end
  end
end 