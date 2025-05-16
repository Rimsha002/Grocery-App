ActiveAdmin.register Product do
  permit_params :name, :description, :price, :compare_at_price, :sku,
                :stock_quantity, :unit, :category_id, :brand, :featured,
                :active, :position, :metadata, labels: [], images: []

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price do |product|
      number_to_currency(product.price)
    end
    column :stock_quantity
    column :active
    column :featured
    column :created_at
    actions
  end

  filter :name
  filter :category
  filter :brand
  filter :price
  filter :stock_quantity
  filter :active
  filter :featured
  filter :created_at

  form do |f|
    f.inputs do
      f.input :category
      f.input :name
      f.input :description, as: :text
      f.input :price
      f.input :compare_at_price
      f.input :sku
      f.input :stock_quantity
      f.input :unit
      f.input :brand
      f.input :featured
      f.input :active
      f.input :position
      f.input :labels, as: :tags
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :category
      row :price do |product|
        number_to_currency(product.price)
      end
      row :compare_at_price do |product|
        number_to_currency(product.compare_at_price)
      end
      row :sku
      row :stock_quantity
      row :unit
      row :brand
      row :featured
      row :active
      row :position
      row :labels
      row :created_at
      row :updated_at
    end

    panel "Images" do
      div do
        product.images.each do |image|
          span do
            image_tag url_for(image), size: '200x200'
          end
        end
      end
    end

    panel "Reviews" do
      table_for product.reviews.includes(:user) do
        column :user
        column :rating
        column :comment
        column :created_at
      end
    end
  end

  sidebar "Product Details", only: :show do
    attributes_table_for resource do
      row :stock_quantity
      row("Status") { status_tag(resource.active? ? "Active" : "Inactive") }
      row("Featured") { status_tag(resource.featured? ? "Yes" : "No") }
    end
  end
end 