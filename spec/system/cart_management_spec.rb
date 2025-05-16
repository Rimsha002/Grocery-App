require 'rails_helper'

RSpec.describe 'Cart Management', type: :system do
  let(:user) { create(:user) }
  let(:product) { create(:product, :with_images) }

  before do
    driven_by(:selenium_chrome_headless)
    sign_in user
  end

  describe 'adding items to cart' do
    it 'adds a product to cart with JavaScript', js: true do
      visit product_path(product)
      
      expect {
        click_button 'Add to Cart'
        # Wait for the cart to update
        expect(page).to have_content('Item added to cart')
      }.to change(CartItem, :count).by(1)
    end
  end

  describe 'updating cart quantities', js: true do
    let!(:cart_item) { create(:cart_item, user: user, product: product, quantity: 1) }

    before do
      visit cart_path
    end

    it 'increases item quantity' do
      within("[data-controller='cart']") do
        click_button '+'
        # Wait for the quantity to update
        expect(page).to have_field('Quantity', with: '2')
      end
      # Wait for the total to update
      expect(page).to have_content('$' + (product.price * 2).to_s)
    end

    it 'decreases item quantity' do
      # First increase quantity to 2
      within("[data-controller='cart']") do
        click_button '+'
        expect(page).to have_field('Quantity', with: '2')
        
        # Then decrease back to 1
        click_button '-'
        expect(page).to have_field('Quantity', with: '1')
      end
    end

    it 'removes item from cart' do
      expect {
        click_button 'Remove'
        # Wait for the item to be removed
        expect(page).not_to have_content(product.name)
      }.to change(CartItem, :count).by(-1)
    end
  end

  describe 'cart total calculation', js: true do
    let!(:cart_item1) { create(:cart_item, user: user, product: create(:product, price: 10.00), quantity: 2) }
    let!(:cart_item2) { create(:cart_item, user: user, product: create(:product, price: 15.00), quantity: 1) }

    it 'updates cart total when quantities change' do
      visit cart_path
      
      # Initial total should be (10.00 * 2) + (15.00 * 1) = 35.00
      expect(page).to have_content('$35.00')

      # Increase first item quantity
      within(all("[data-controller='cart']")[0]) do
        click_button '+'
        # Wait for the quantity to update
      end

      # New total should be (10.00 * 3) + (15.00 * 1) = 45.00
      expect(page).to have_content('$45.00')
    end
  end
end 