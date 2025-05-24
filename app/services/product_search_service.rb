class ProductSearchService
    attr_reader :params
  
    def initialize(params = {})
      @params = params
    end
  
    def call
      products = Product.active.includes(:category, :reviews)
      products = apply_search(products)
      products = apply_category_filter(products)
      products = apply_price_filter(products)
      products = apply_brand_filter(products)
      products = apply_rating_filter(products)
      products = apply_stock_filter(products)
      products = apply_sorting(products)
      products
    end
  
    private
  
    def apply_search(products)
      if params[:query].present?
        products.search(params[:query])
      else
        products
      end
    end
  
    def apply_category_filter(products)
      if params[:category].present?
        products.where(category_id: params[:category])
      else
        products
      end
    end
  
    def apply_price_filter(products)
      products = products.where('price >= ?', params[:min_price]) if params[:min_price].present?
      products = products.where('price <= ?', params[:max_price]) if params[:max_price].present?
      products
    end
  
    def apply_brand_filter(products)
      if params[:brand].present?
        products.where(brand: params[:brand])
      else
        products
      end
    end
  
    def apply_rating_filter(products)
      if params[:min_rating].present?
        products.where('rating >= ?', params[:min_rating])
      else
        products
      end
    end
  
    def apply_stock_filter(products)
      case params[:stock]
      when 'in_stock'
        products.in_stock
      when 'out_of_stock'
        products.where(stock_quantity: 0)
      else
        products
      end
    end
  
    def apply_sorting(products)
      case params[:sort]
      when 'price_asc'
        products.order(price: :asc)
      when 'price_desc'
        products.order(price: :desc)
      when 'newest'
        products.order(created_at: :desc)
      when 'rating'
        products.order(rating: :desc)
      else
        products.order(created_at: :desc)
      end
    end
  end