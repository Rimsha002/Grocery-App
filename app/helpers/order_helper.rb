module OrderHelper
  def status_color(status)
    case status.to_sym
    when :pending
      '#FFA500' # Orange
    when :confirmed
      '#3498DB' # Blue
    when :preparing
      '#9B59B6' # Purple
    when :out_for_delivery
      '#2ECC71' # Green
    when :delivered
      '#27AE60' # Dark Green
    when :cancelled
      '#E74C3C' # Red
    else
      '#95A5A6' # Gray
    end
  end

  def status_message(status)
    case status.to_sym
    when :pending
      'Your order has been received and is awaiting confirmation.'
    when :confirmed
      'Your order has been confirmed and will be prepared soon.'
    when :preparing
      'We are now preparing your order with fresh items.'
    when :out_for_delivery
      'Your order is on its way! Our delivery partner will arrive soon.'
    when :delivered
      'Your order has been delivered. Enjoy your groceries!'
    when :cancelled
      'Your order has been cancelled. Please contact support if you have any questions.'
    else
      'Status update for your order.'
    end
  end
end 