require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:order_items).dependent(:restrict_with_error) }
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:wishlist_items).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(255) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:stock_quantity) }
    it { should validate_numericality_of(:stock_quantity).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) }
    it { should validate_uniqueness_of(:sku).allow_blank }
    it { should validate_presence_of(:unit) }
    it { should validate_presence_of(:description) }
  end

  describe 'scopes' do
    let!(:active_product) { create(:product, active: true) }
    let!(:inactive_product) { create(:product, active: false) }
    let!(:featured_product) { create(:product, featured: true) }
    let!(:out_of_stock_product) { create(:product, stock_quantity: 0) }

    it 'active returns only active products' do
      expect(Product.active).to include(active_product)
      expect(Product.active).not_to include(inactive_product)
    end

    it 'featured returns only featured products' do
      expect(Product.featured).to include(featured_product)
      expect(Product.featured).not_to include(active_product)
    end

    it 'in_stock returns products with stock_quantity > 0' do
      expect(Product.in_stock).to include(active_product)
      expect(Product.in_stock).not_to include(out_of_stock_product)
    end
  end

  describe 'instance methods' do
    let(:product) { create(:product, price: 80, compare_at_price: 100, stock_quantity: 3) }

    describe '#discount_percentage' do
      it 'calculates correct discount percentage' do
        expect(product.discount_percentage).to eq(20)
      end

      it 'returns 0 when no compare_at_price' do
        product.compare_at_price = nil
        expect(product.discount_percentage).to eq(0)
      end
    end

    describe '#in_stock?' do
      it 'returns true when stock_quantity > 0' do
        expect(product.in_stock?).to be true
      end

      it 'returns false when stock_quantity = 0' do
        product.stock_quantity = 0
        expect(product.in_stock?).to be false
      end
    end

    describe '#low_stock?' do
      it 'returns true when stock_quantity <= 5 and > 0' do
        expect(product.low_stock?).to be true
      end

      it 'returns false when stock_quantity > 5' do
        product.stock_quantity = 6
        expect(product.low_stock?).to be false
      end
    end

    describe '#update_stock' do
      it 'decreases stock_quantity by given amount' do
        expect { product.update_stock(2) }.to change { product.stock_quantity }.by(-2)
      end
    end
  end

  describe 'recommendation system' do
    let(:user) { create(:user) }
    let(:category) { create(:category) }
    let!(:product1) { create(:product, category: category, rating: 5) }
    let!(:product2) { create(:product, category: category, rating: 4) }
    let!(:product3) { create(:product, category: category, rating: 3) }
    let!(:order) { create(:order, user: user) }
    let!(:order_item) { create(:order_item, order: order, product: product1) }

    describe '.recommended_for_user' do
      it 'returns products from categories the user has ordered from' do
        recommendations = Product.recommended_for_user(user)
        expect(recommendations).to include(product2)
        expect(recommendations).not_to include(product1) # Already ordered
      end

      it 'returns popular products for new users' do
        new_user = create(:user)
        recommendations = Product.recommended_for_user(new_user)
        expect(recommendations).to include(product1, product2)
      end
    end

    describe '.popular_products' do
      it 'returns products ordered by number of orders and rating' do
        create(:order_item, product: product2)
        create(:order_item, product: product2)
        popular = Product.popular_products
        expect(popular.first).to eq(product2)
      end
    end

    describe '#similar_products' do
      it 'returns products from the same category' do
        other_category = create(:category)
        other_product = create(:product, category: other_category)
        
        similar = product1.similar_products
        expect(similar).to include(product2)
        expect(similar).not_to include(other_product)
      end

      it 'excludes the current product' do
        similar = product1.similar_products
        expect(similar).not_to include(product1)
      end

      it 'orders by rating' do
        similar = product1.similar_products
        expect(similar.first).to eq(product2) # Second highest rating after product1
      end
    end
  end
end 