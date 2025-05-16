class CartsController < ApplicationController
  def show
    @cart = current_cart
    @recommended_products = Product.active.featured.limit(4)
  end

  def add_item
    @cart = current_cart
    @product = Product.active.find(params[:product_id])
    quantity = params[:quantity].to_i || 1

    if @product.stock_quantity >= quantity
      @cart.add_item(@product, quantity)
      flash[:notice] = 'Item added to cart successfully.'
    else
      flash[:alert] = 'Sorry, the requested quantity is not available.'
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end

  def remove_item
    @cart = current_cart
    @product = Product.find(params[:product_id])
    @cart.remove_item(@product)

    respond_to do |format|
      format.html { redirect_to cart_path, notice: 'Item removed from cart.' }
      format.turbo_stream
    end
  end

  def update_quantity
    @cart = current_cart
    @product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    if quantity > 0 && quantity <= @product.stock_quantity
      @cart.update_item_quantity(@product, quantity)
      flash[:notice] = 'Cart updated successfully.'
    else
      flash[:alert] = 'Invalid quantity specified.'
    end

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.turbo_stream
    end
  end

  def clear
    current_cart.clear!
    redirect_to cart_path, notice: 'Cart cleared successfully.'
  end
end 