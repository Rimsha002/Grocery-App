ActiveAdmin.register Order do
  permit_params :user_id, :status, :payment_status, :payment_method,
                :shipping_address, :billing_address, :notes,
                :subtotal, :tax, :shipping, :total

  actions :all, except: [:new, :create]

  scope :all
  scope :pending
  scope :processing
  scope :shipped
  scope :delivered
  scope :cancelled

  index do
    selectable_column
    id_column
    column :user
    column :status do |order|
      status_tag(order.status)
    end
    column :payment_status do |order|
      status_tag(order.payment_status)
    end
    column :total do |order|
      number_to_currency(order.total)
    end
    column :created_at
    actions
  end

  filter :id
  filter :user
  filter :status, as: :select
  filter :payment_status, as: :select
  filter :total
  filter :created_at

  show do
    attributes_table do
      row :id
      row :user
      row :status do |order|
        status_tag(order.status)
      end
      row :payment_status do |order|
        status_tag(order.payment_status)
      end
      row :payment_method
      row :shipping_address
      row :billing_address
      row :subtotal do |order|
        number_to_currency(order.subtotal)
      end
      row :tax do |order|
        number_to_currency(order.tax)
      end
      row :shipping do |order|
        number_to_currency(order.shipping)
      end
      row :total do |order|
        number_to_currency(order.total)
      end
      row :notes
      row :created_at
      row :paid_at
      row :shipped_at
      row :delivered_at
      row :cancelled_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :unit_price do |item|
          number_to_currency(item.unit_price)
        end
        column :total_price do |item|
          number_to_currency(item.total_price)
        end
      end
    end
  end

  sidebar "Order Actions", only: :show do
    attributes_table_for resource do
      if resource.pending?
        row("Action") { link_to "Mark Processing", mark_processing_admin_order_path(resource), method: :patch, class: "button" }
      elsif resource.processing?
        row("Action") { link_to "Mark Shipped", mark_shipped_admin_order_path(resource), method: :patch, class: "button" }
      elsif resource.shipped?
        row("Action") { link_to "Mark Delivered", mark_delivered_admin_order_path(resource), method: :patch, class: "button" }
      end
      
      unless resource.cancelled?
        row("Cancel") { link_to "Cancel Order", mark_cancelled_admin_order_path(resource), method: :patch, class: "button", data: { confirm: "Are you sure?" } }
      end
    end
  end

  member_action :mark_processing, method: :patch do
    resource.update(status: :processing)
    redirect_to resource_path, notice: "Order marked as processing"
  end

  member_action :mark_shipped, method: :patch do
    resource.mark_as_shipped!
    redirect_to resource_path, notice: "Order marked as shipped"
  end

  member_action :mark_delivered, method: :patch do
    resource.mark_as_delivered!
    redirect_to resource_path, notice: "Order marked as delivered"
  end

  member_action :mark_cancelled, method: :patch do
    resource.mark_as_cancelled!
    redirect_to resource_path, notice: "Order marked as cancelled"
  end
end 