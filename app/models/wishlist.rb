class Wishlist < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :wishlist_items, dependent: :destroy
  has_many :products, through: :wishlist_items

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :user_id, presence: true

  # Scopes
  scope :public_lists, -> { where(public: true) }
  scope :private_lists, -> { where(public: false) }

  def add_product(product, note = nil)
    wishlist_items.find_or_create_by(product: product) do |item|
      item.note = note
    end
  end

  def remove_product(product)
    wishlist_items.where(product: product).destroy_all
  end

  def has_product?(product)
    products.include?(product)
  end
end 