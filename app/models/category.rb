class Category < ApplicationRecord
  # Associations
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :products, dependent: :nullify
  has_one_attached :icon

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :slug, presence: true, uniqueness: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Callbacks
  before_validation :generate_slug, if: :name_changed?
  before_save :ensure_position

  # Scopes
  scope :root_categories, -> { where(parent_id: nil) }
  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :ordered, -> { order(position: :asc) }

  private

  def generate_slug
    self.slug = name.to_s.parameterize
  end

  def ensure_position
    self.position ||= (Category.maximum(:position) || 0) + 1
  end
end 