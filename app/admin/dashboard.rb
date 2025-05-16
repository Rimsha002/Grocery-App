ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Orders" do
          table_for Order.order(created_at: :desc).limit(5) do
            column("Order") { |order| link_to("##{order.id}", admin_order_path(order)) }
            column("Status") { |order| status_tag(order.status) }
            column("Customer") { |order| link_to(order.user.full_name, admin_user_path(order.user)) }
            column("Total") { |order| number_to_currency(order.total) }
            column("Date") { |order| order.created_at.strftime("%B %d, %Y") }
          end
          text_node link_to("View All Orders", admin_orders_path, class: "button")
        end
      end

      column do
        panel "Statistics" do
          div class: "statistics" do
            div do
              h3 Order.count
              para "Total Orders"
            end

            div do
              h3 Order.where(status: :pending).count
              para "Pending Orders"
            end

            div do
              h3 Product.count
              para "Total Products"
            end

            div do
              h3 Product.where('stock_quantity < 10').count
              para "Low Stock Products"
            end

            div do
              h3 User.count
              para "Registered Users"
            end
          end
        end

        panel "Recent Products" do
          table_for Product.order(created_at: :desc).limit(5) do
            column("Product") { |product| link_to(product.name, admin_product_path(product)) }
            column("Category") { |product| product.category.name }
            column("Price") { |product| number_to_currency(product.price) }
            column("Stock") { |product| product.stock_quantity }
          end
        end
      end
    end
  end
end 