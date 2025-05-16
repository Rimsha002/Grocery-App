class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :cancel]

  def index
    @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
  end

  def show
  end

  def create
    @cart = current_cart
    
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty.'
      return
    end

    @order = current_user.orders.build(order_params)
    @order.build_from_cart(@cart)

    if @order.save
      @cart.clear!
      session[:cart_id] = nil
      # Here you would typically integrate with a payment gateway
      redirect_to @order, notice: 'Order was successfully created.'
    else
      redirect_to cart_path, alert: 'Unable to create order.'
    end
  end

  def cancel
    if @order.pending? || @order.processing?
      @order.mark_as_cancelled!
      redirect_to @order, notice: 'Order was successfully cancelled.'
    else
      redirect_to @order, alert: 'This order cannot be cancelled.'
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :shipping_address,
      :billing_address,
      :payment_method,
      :notes
    )
  end
end 