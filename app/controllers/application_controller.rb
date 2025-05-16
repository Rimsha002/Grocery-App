class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_cart
  
  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :address, :avatar])
  end

  def set_current_cart
    return if current_user&.cart

    if session[:cart_id]
      @current_cart = Cart.find_by(id: session[:cart_id])
    end

    if @current_cart.nil?
      @current_cart = Cart.create(session_id: session.id)
      session[:cart_id] = @current_cart.id
    end

    # Transfer cart to user if they just logged in
    if current_user && @current_cart.user_id.nil?
      @current_cart.update(user: current_user)
      current_user.cart&.destroy if current_user.cart && current_user.cart != @current_cart
    end
  end

  def current_cart
    @current_cart ||= set_current_cart
  end
  helper_method :current_cart
end
