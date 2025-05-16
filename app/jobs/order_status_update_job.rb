class OrderStatusUpdateJob < ApplicationJob
  queue_as :mailers

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order

    OrderMailer.status_update_email(order).deliver_now
  end
end 