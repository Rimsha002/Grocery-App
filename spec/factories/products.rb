FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    price { Faker::Commerce.price(range: 0..100.0) }
    compare_at_price { price * 1.2 }
    stock_quantity { Faker::Number.between(from: 1, to: 100) }
    unit { %w[kg piece pack].sample }
    brand { Faker::Company.name }
    active { true }
    featured { false }
    position { Faker::Number.between(from: 1, to: 1000) }
    sku { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
    slug { name.parameterize }
    association :category

    trait :with_images do
      after(:build) do |product|
        product.images.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'product.jpg')),
          filename: 'product.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :out_of_stock do
      stock_quantity { 0 }
    end

    trait :featured do
      featured { true }
    end

    trait :inactive do
      active { false }
    end

    trait :with_reviews do
      after(:create) do |product|
        create_list(:review, 3, product: product)
      end
    end
  end
end 