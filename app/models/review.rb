class Review < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :product

  # Validations
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :user_id, uniqueness: { scope: :product_id, message: 'has already reviewed this product' }

  # Scopes
  scope :approved, -> { where.not(approved_at: nil) }
  scope :pending, -> { where(approved_at: nil) }
  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_rating, -> { order(rating: :desc) }

  # Callbacks
  after_save :update_product_rating
  after_destroy :update_product_rating

  def approve!
    update!(approved_at: Time.current)
  end

  def approved?
    approved_at.present?
  end

  private

  def update_product_rating
    product.update_column(:average_rating, product.reviews.average(:rating))
  end
end 