class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :product_must_be_available

  # Callbacks
  before_validation :set_unit_price
  before_save :calculate_total_price

  private

  def set_unit_price
    self.unit_price = product.price if unit_price.nil? && product.present?
  end

  def calculate_total_price
    self.total_price = quantity * unit_price if quantity.present? && unit_price.present?
  end

  def product_must_be_available
    return unless product
    return if product.active? && product.stock_quantity >= quantity

    errors.add(:product, 'is not available in the requested quantity')
  end
end 