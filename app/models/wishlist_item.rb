class WishlistItem < ApplicationRecord
  # Associations
  belongs_to :wishlist
  belongs_to :product

  # Validations
  validates :wishlist_id, uniqueness: { scope: :product_id, message: 'already has this product' }
  validates :note, length: { maximum: 500 }

  # Callbacks
  after_save :update_wishlist_timestamp
  after_destroy :update_wishlist_timestamp

  private

  def update_wishlist_timestamp
    wishlist.touch
  end
end 