module CartHelper
  def cart_count
    return 0 unless user_signed_in? && current_user.cart.present?
    
    # If you have a Cart model with line_items
    current_user.cart.line_items.sum(:quantity)
    
    # Or if you're storing cart in session
    # session[:cart]&.values&.sum || 0
  end
end