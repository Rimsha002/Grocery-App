# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
AdminUser.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
) if Rails.env.development?

# Create categories
categories = [
  'Fruits & Vegetables',
  'Dairy & Eggs',
  'Meat & Seafood',
  'Bakery',
  'Pantry',
  'Beverages',
  'Snacks',
  'Household'
].map do |name|
  Category.create!(
    name: name,
    description: "Fresh #{name.downcase} and related products",
    active: true,
    position: Category.count + 1
  )
end

# Create sample products
categories.each do |category|
  10.times do
    Product.create!(
      name: Faker::Food.unique.dish,
      description: Faker::Food.description,
      price: Faker::Commerce.price(range: 1..100.0),
      compare_at_price: Faker::Commerce.price(range: 101..200.0),
      stock_quantity: Faker::Number.between(from: 0, to: 100),
      unit: ['kg', 'piece', 'pack'].sample,
      brand: Faker::Company.name,
      active: true,
      featured: Faker::Boolean.boolean(true_ratio: 0.2),
      category: category,
      rating: Faker::Number.between(from: 3, to: 5)
    )
  end
end
