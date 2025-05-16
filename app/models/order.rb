class Order < ApplicationRecord
  # Enums
  enum status: {
    pending: 0,
    confirmed: 1,
    preparing: 2,
    out_for_delivery: 3,
    delivered: 4,
    cancelled: 5
  }

  enum payment_status: {
    unpaid: 'unpaid',
    paid: 'paid',
    refunded: 'refunded'
  }

  # Associations
  belongs_to :user
  belongs_to :address
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Validations
  validates :status, presence: true
  validates :payment_status, presence: true
  validates :shipping_address, presence: true
  validates :billing_address, presence: true
  validates :subtotal, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax, :shipping, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :delivery_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_validation :set_default_statuses, on: :create
  before_save :calculate_total
  after_create :send_confirmation_email
  after_update :send_status_update_email, if: :saved_change_to_status?

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :completed, -> { where(status: ['shipped', 'delivered']) }
  scope :by_status, ->(status) { where(status: status) }
  scope :today, -> { where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :this_week, -> { where(created_at: Time.current.beginning_of_week..Time.current.end_of_week) }
  scope :this_month, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }

  def mark_as_paid!
    update!(
      payment_status: 'paid',
      paid_at: Time.current
    )
  end

  def mark_as_shipped!
    update!(
      status: 'shipped',
      shipped_at: Time.current
    )
  end

  def mark_as_delivered!
    update!(
      status: 'delivered',
      delivered_at: Time.current
    )
  end

  def mark_as_cancelled!
    update!(
      status: 'cancelled',
      cancelled_at: Time.current
    )
  end

  def calculate_total
    self.subtotal = order_items.sum { |item| item.quantity * item.unit_price }
    self.total = subtotal + delivery_fee - (discount_amount || 0)
  end

  def apply_discount(code)
    discount = Discount.active.find_by(code: code)
    return false unless discount&.valid_for?(self)

    self.discount = discount
    self.discount_amount = discount.calculate_discount(subtotal)
    calculate_total
    true
  end

  def estimated_delivery_time
    return nil unless confirmed?
    created_at + 2.hours
  end

  private

  def set_default_statuses
    self.status ||= 'pending'
    self.payment_status ||= 'unpaid'
  end

  def send_confirmation_email
    OrderConfirmationJob.perform_later(id)
  end

  def send_status_update_email
    OrderStatusUpdateJob.perform_later(id)
  end
end 