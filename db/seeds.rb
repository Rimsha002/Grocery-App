# Create admin user
admin = AdminUser.find_or_create_by!(email: 'testadmin@example.com') do |admin|
  admin.password = 'password123'
  admin.password_confirmation = 'password123'
end

# Create regular user
user = User.find_or_create_by!(email: 'testuser@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Test'
  user.last_name = 'User'
  user.phone_number = '+1234567890'
end

# Create categories
categories = [
  { name: 'Fruits & Vegetables' },
  { name: 'Dairy & Eggs' },
  { name: 'Bakery' },
  { name: 'Meat & Seafood' },
  { name: 'Snacks & Beverages' }
]

categories.each do |category|
  Category.find_or_create_by!(name: category[:name])
end

# Create products
products = [
  {
    name: 'Organic Bananas',
    description: 'Fresh organic bananas, perfect for snacking',
    price: 2.99,
    stock_quantity: 100,
    unit: 'bunch',
    category: Category.find_by(name: 'Fruits & Vegetables')
  },
  {
    name: 'Whole Milk',
    description: 'Fresh whole milk, 1 gallon',
    price: 3.99,
    stock_quantity: 50,
    unit: 'gallon',
    category: Category.find_by(name: 'Dairy & Eggs')
  },
  {
    name: 'Sourdough Bread',
    description: 'Freshly baked sourdough bread',
    price: 4.99,
    stock_quantity: 30,
    unit: 'loaf',
    category: Category.find_by(name: 'Bakery')
  },
  {
    name: 'Chicken Breast',
    description: 'Boneless chicken breast, 1lb',
    price: 5.99,
    stock_quantity: 40,
    unit: 'pound',
    category: Category.find_by(name: 'Meat & Seafood')
  },
  {
    name: 'Potato Chips',
    description: 'Classic salted potato chips',
    price: 2.49,
    stock_quantity: 75,
    unit: 'bag',
    category: Category.find_by(name: 'Snacks & Beverages')
  }
]

products.each do |product|
  Product.find_or_create_by!(name: product[:name]) do |p|
    p.description = product[:description]
    p.price = product[:price]
    p.stock_quantity = product[:stock_quantity]
    p.unit = product[:unit]
    p.category = product[:category]
  end
end

puts "Seed data created successfully!"
puts "Admin email: testadmin@example.com"
puts "Admin password: password123"
puts "User email: testuser@example.com"
puts "User password: password123"