class OrderMailer < ApplicationMailer
  def confirmation_email(order)
    @order = order
    @user = order.user
    mail(to: @user.email, subject: 'Order Confirmation - GrocerApp')
  end

  def status_update_email(order)
    @order = order
    @user = order.user
    mail(to: @user.email, subject: "Order Status Update - #{order.status.titleize}")
  end

  def delivery_confirmation_email(order)
    @order = order
    @user = order.user
    mail(to: @user.email, subject: 'Your Order Has Been Delivered - GrocerApp')
  end
end 