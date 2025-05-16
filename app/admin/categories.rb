ActiveAdmin.register Category do
  permit_params :name, :description, :parent_id, :position,
                :featured, :active, :icon

  index do
    selectable_column
    id_column
    column :name
    column :parent
    column :position
    column :featured
    column :active
    column :products_count do |category|
      category.products.count
    end
    column :created_at
    actions
  end

  filter :name
  filter :parent
  filter :featured
  filter :active
  filter :created_at

  form do |f|
    f.inputs do
      f.input :parent, collection: Category.where.not(id: resource.id)
      f.input :name
      f.input :description
      f.input :position
      f.input :featured
      f.input :active
      f.input :icon, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :parent
      row :position
      row :featured
      row :active
      row :created_at
      row :updated_at
      row :icon do |category|
        image_tag url_for(category.icon) if category.icon.attached?
      end
    end

    panel "Products" do
      table_for category.products do
        column :name
        column :price do |product|
          number_to_currency(product.price)
        end
        column :stock_quantity
        column :active
        column :actions do |product|
          links = []
          links << link_to("View", admin_product_path(product))
          links << link_to("Edit", edit_admin_product_path(product))
          links.join(" | ").html_safe
        end
      end
    end

    panel "Subcategories" do
      table_for category.subcategories do
        column :name
        column :products_count do |subcat|
          subcat.products.count
        end
        column :active
        column :actions do |subcat|
          links = []
          links << link_to("View", admin_category_path(subcat))
          links << link_to("Edit", edit_admin_category_path(subcat))
          links.join(" | ").html_safe
        end
      end
    end
  end

  sidebar "Category Details", only: :show do
    attributes_table_for resource do
      row("Status") { status_tag(resource.active? ? "Active" : "Inactive") }
      row("Featured") { status_tag(resource.featured? ? "Yes" : "No") }
      row :products_count do |category|
        category.products.count
      end
    end
  end
end 