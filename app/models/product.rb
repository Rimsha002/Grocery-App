class Product < ApplicationRecord
  # Associations
  belongs_to :category, touch: true
  has_many :order_items, dependent: :restrict_with_error
  has_many :cart_items, dependent: :destroy
  has_many :wishlist_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :images

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :compare_at_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :slug, presence: true, uniqueness: true
  validates :sku, uniqueness: true, allow_blank: true
  validates :unit, presence: true
  validates :description, presence: true

  # Callbacks
  before_validation :generate_slug, if: :name_changed?
  before_save :ensure_position

  # Scopes
  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :ordered, -> { order(position: :asc) }
  scope :with_discount, -> { where('compare_at_price > price') }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :price_range, ->(min, max) { where('price >= ? AND price <= ?', min, max) }
  scope :by_rating, ->(rating) { where('rating >= ?', rating) }

  # Search
  include PgSearch::Model
  pg_search_scope :search,
                 against: {
                   name: 'A',
                   description: 'B',
                   brand: 'C'
                 },
                 using: {
                   tsearch: { prefix: true, dictionary: 'english' },
                   trigram: { threshold: 0.3 }
                 }

  # Cache versioning
  after_commit :touch_category
  after_touch :touch_related_products

  # Recommendation System
  def self.recommended_for_user(user, limit: 10)
    return popular_products(limit) unless user

    user_categories = user.orders.joins(order_items: :product)
                         .select('products.category_id')
                         .distinct
                         .pluck(:category_id)

    if user_categories.any?
      where(category_id: user_categories)
        .where.not(id: user.ordered_product_ids)
        .active
        .order(rating: :desc)
        .limit(limit)
    else
      popular_products(limit)
    end
  end

  def self.popular_products(limit = 10)
    active
      .left_joins(:order_items)
      .group(:id)
      .order('COUNT(order_items.id) DESC, rating DESC')
      .limit(limit)
  end

  def similar_products(limit: 4)
    Product.active
           .where(category_id: category_id)
           .where.not(id: id)
           .order(rating: :desc)
           .limit(limit)
  end

  def discount_percentage
    return 0 unless compare_at_price && compare_at_price > price
    ((compare_at_price - price) / compare_at_price * 100).round
  end

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  def in_stock?
    stock_quantity.positive?
  end

  def low_stock?
    stock_quantity <= 5 && stock_quantity.positive?
  end

  def update_stock(quantity)
    update(stock_quantity: stock_quantity - quantity)
  end

  private

  def generate_slug
    self.slug = name.to_s.parameterize
  end

  def ensure_position
    self.position ||= (Product.maximum(:position) || 0) + 1
  end

  def touch_category
    category.touch if category.present?
  end

  def touch_related_products
    category.products.where.not(id: id).update_all(updated_at: Time.current) if category.present?
  end
end 