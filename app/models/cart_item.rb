class CartItem < ApplicationRecord
  # Associations
  belongs_to :cart
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :product_must_be_available

  # Callbacks
  before_validation :set_unit_price
  after_save :update_cart_timestamp
  after_destroy :update_cart_timestamp

  def total_price
    quantity * unit_price
  end

  private

  def set_unit_price
    self.unit_price = product.price if unit_price.nil? && product.present?
  end

  def update_cart_timestamp
    cart.touch
  end

  def product_must_be_available
    return unless product
    return if product.active? && product.stock_quantity >= quantity

    errors.add(:quantity, 'exceeds available stock')
  end
end 