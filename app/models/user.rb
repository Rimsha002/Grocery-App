class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Associations
  has_many :orders, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :wishlists, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_one_attached :avatar

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :phone_number, presence: true, format: { with: /\A\+?\d{10,15}\z/ }

  # Callbacks
  after_create :create_default_wishlist

  def full_name
    "#{first_name} #{last_name}"
  end

  def wishlisted?(product)
    wishlists.joins(:wishlist_items).exists?(wishlist_items: { product_id: product.id })
  end

  def ordered_product_ids
    orders.joins(:order_items).pluck('order_items.product_id').uniq
  end

  private

  def create_default_wishlist
    wishlists.create(name: 'My Wishlist')
  end
end 