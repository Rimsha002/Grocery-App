class WishlistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]

  def index
    @wishlists = current_user.wishlists.includes(:products)
  end

  def show
    @products = @wishlist.products.includes(:category)
  end

  def new
    @wishlist = current_user.wishlists.build
  end

  def create
    @wishlist = current_user.wishlists.build(wishlist_params)

    if @wishlist.save
      redirect_to @wishlist, notice: 'Wishlist was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @wishlist.update(wishlist_params)
      redirect_to @wishlist, notice: 'Wishlist was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wishlist.destroy
    redirect_to wishlists_url, notice: 'Wishlist was successfully deleted.'
  end

  def add_product
    @wishlist = current_user.wishlists.find(params[:id])
    @product = Product.find(params[:product_id])
    @note = params[:note]

    @wishlist.add_product(@product, @note)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: 'Product added to wishlist.') }
      format.turbo_stream
    end
  end

  def remove_product
    @wishlist = current_user.wishlists.find(params[:id])
    @product = Product.find(params[:product_id])

    @wishlist.remove_product(@product)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: 'Product removed from wishlist.') }
      format.turbo_stream
    end
  end

  private

  def set_wishlist
    @wishlist = current_user.wishlists.find(params[:id])
  end

  def wishlist_params
    params.require(:wishlist).permit(:name, :public)
  end
end 