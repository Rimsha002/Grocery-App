class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.string :slug
      t.references :parent, null: true, foreign_key: { to_table: :categories }
      t.integer :position
      t.string :icon
      t.boolean :featured, default: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :categories, :slug, unique: true
  end
end 