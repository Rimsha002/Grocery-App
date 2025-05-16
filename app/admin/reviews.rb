ActiveAdmin.register Review do
  permit_params :user_id, :product_id, :rating, :comment,
                :verified_purchase, :featured, :approved_at

  scope :all
  scope :pending
  scope :approved
  scope :featured

  index do
    selectable_column
    id_column
    column :user
    column :product
    column :rating
    column :comment do |review|
      truncate(review.comment, length: 50)
    end
    column :verified_purchase
    column :featured
    column :approved_at
    column :created_at
    actions
  end

  filter :user
  filter :product
  filter :rating
  filter :verified_purchase
  filter :featured
  filter :approved_at
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user
      f.input :product
      f.input :rating
      f.input :comment
      f.input :verified_purchase
      f.input :featured
      f.input :approved_at, as: :datetime_picker
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :product
      row :rating
      row :comment
      row :verified_purchase
      row :featured
      row :approved_at
      row :created_at
      row :updated_at
    end
  end

  batch_action :approve do |ids|
    batch_action_collection.find(ids).each do |review|
      review.update(approved_at: Time.current)
    end
    redirect_to collection_path, notice: "Reviews have been approved"
  end

  batch_action :unapprove do |ids|
    batch_action_collection.find(ids).each do |review|
      review.update(approved_at: nil)
    end
    redirect_to collection_path, notice: "Reviews have been unapproved"
  end

  batch_action :feature do |ids|
    batch_action_collection.find(ids).each do |review|
      review.update(featured: true)
    end
    redirect_to collection_path, notice: "Reviews have been featured"
  end

  batch_action :unfeature do |ids|
    batch_action_collection.find(ids).each do |review|
      review.update(featured: false)
    end
    redirect_to collection_path, notice: "Reviews have been unfeatured"
  end

  member_action :approve, method: :put do
    resource.update(approved_at: Time.current)
    redirect_to resource_path, notice: "Review has been approved"
  end

  member_action :unapprove, method: :put do
    resource.update(approved_at: nil)
    redirect_to resource_path, notice: "Review has been unapproved"
  end

  action_item :approve, only: :show, if: proc { !resource.approved? } do
    link_to "Approve", approve_admin_review_path(resource), method: :put
  end

  action_item :unapprove, only: :show, if: proc { resource.approved? } do
    link_to "Unapprove", unapprove_admin_review_path(resource), method: :put
  end
end 