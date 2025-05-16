require 'rails_helper'

RSpec.describe 'Search', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  let!(:category) { create(:category, name: 'Fruits') }
  let!(:apple) { create(:product, name: 'Red Apple', category: category, price: 2.99) }
  let!(:banana) { create(:product, name: 'Yellow Banana', category: category, price: 1.99) }
  let!(:orange) { create(:product, name: 'Fresh Orange', category: category, price: 3.99) }

  describe 'search functionality', js: true do
    before do
      visit root_path
    end

    it 'shows search results as user types' do
      within("[data-controller='search']") do
        fill_in 'Search products', with: 'app'
        # Wait for search results
        expect(page).to have_content('Red Apple')
        expect(page).not_to have_content('Yellow Banana')
      end
    end

    it 'shows no results message when no matches found' do
      within("[data-controller='search']") do
        fill_in 'Search products', with: 'xyz123'
        # Wait for no results message
        expect(page).to have_content('No products found')
      end
    end

    it 'filters results by category' do
      visit products_path
      select 'Fruits', from: 'Category'
      expect(page).to have_content('Red Apple')
      expect(page).to have_content('Yellow Banana')
      expect(page).to have_content('Fresh Orange')
    end

    it 'filters results by price range' do
      visit products_path
      fill_in 'Min Price', with: '2'
      fill_in 'Max Price', with: '3'
      click_button 'Apply Filters'
      
      expect(page).to have_content('Red Apple')
      expect(page).not_to have_content('Yellow Banana')
      expect(page).not_to have_content('Fresh Orange')
    end

    it 'sorts results by price' do
      visit products_path
      select 'Price: Low to High', from: 'Sort by'
      
      # Check if products are in correct order
      expect(all('.product-card').map { |card| card.find('.price').text }).to eq(
        ['$1.99', '$2.99', '$3.99']
      )
    end
  end

  describe 'search results page' do
    it 'displays search results with pagination' do
      # Create 30 products
      create_list(:product, 30)
      
      visit products_path
      fill_in 'Search products', with: 'product'
      click_button 'Search'

      # Should show first page of results (24 products per page)
      expect(page).to have_selector('.product-card', count: 24)
      expect(page).to have_link('Next')
    end
  end
end 