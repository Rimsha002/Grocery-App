class Cart < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Validations
  validates :session_id, presence: true, unless: :user_id?
  validates :session_id, uniqueness: true, allow_nil: true

  # Scopes
  scope :abandoned, -> { where.not(abandoned_at: nil) }
  scope :active, -> { where(abandoned_at: nil) }

  def add_item(product, quantity = 1)
    current_item = cart_items.find_by(product: product)

    if current_item
      current_item.quantity += quantity
      current_item.save
    else
      cart_items.create(product: product, quantity: quantity, unit_price: product.price)
    end
  end

  def remove_item(product)
    cart_items.where(product: product).destroy_all
  end

  def update_item_quantity(product, quantity)
    cart_items.find_by(product: product)&.update(quantity: quantity)
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def subtotal
    cart_items.sum { |item| item.unit_price * item.quantity }
  end

  def empty?
    cart_items.empty?
  end

  def clear!
    cart_items.destroy_all
  end

  def mark_as_abandoned!
    update(abandoned_at: Time.current)
  end
end 