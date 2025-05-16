ActiveAdmin.register User do
  permit_params :email, :first_name, :last_name, :phone_number,
                :address, :admin, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :phone_number
    column :admin
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :phone_number
  filter :admin
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :phone_number
      f.input :address
      f.input :admin
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :phone_number
      row :address
      row :admin
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
      row :avatar do |user|
        image_tag url_for(user.avatar) if user.avatar.attached?
      end
    end

    panel "Orders" do
      table_for user.orders.order(created_at: :desc) do
        column :id
        column :status do |order|
          status_tag(order.status)
        end
        column :total do |order|
          number_to_currency(order.total)
        end
        column :created_at
        column :actions do |order|
          link_to "View", admin_order_path(order)
        end
      end
    end

    panel "Reviews" do
      table_for user.reviews.includes(:product) do
        column :product
        column :rating
        column :comment
        column :created_at
      end
    end

    panel "Wishlists" do
      table_for user.wishlists do
        column :name
        column :public
        column :created_at
        column :products_count do |wishlist|
          wishlist.products.count
        end
      end
    end
  end

  sidebar "User Stats", only: :show do
    attributes_table_for resource do
      row("Total Orders") { resource.orders.count }
      row("Total Spent") { number_to_currency(resource.orders.sum(:total)) }
      row("Average Order Value") { number_to_currency(resource.orders.average(:total)) }
      row("Reviews Written") { resource.reviews.count }
      row("Wishlists Created") { resource.wishlists.count }
    end
  end
end 