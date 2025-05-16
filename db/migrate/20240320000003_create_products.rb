class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :compare_at_price, precision: 10, scale: 2
      t.string :sku
      t.integer :stock_quantity, default: 0
      t.string :unit # e.g., kg, piece, dozen
      t.string :slug
      t.references :category, null: false, foreign_key: true
      t.string :brand
      t.boolean :featured, default: false
      t.boolean :active, default: true
      t.integer :position
      t.jsonb :metadata, default: {}
      t.string :labels, array: true, default: []

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
    add_index :products, :brand
    add_index :products, :active
    add_index :products, :featured
  end
end 