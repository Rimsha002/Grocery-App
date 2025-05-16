class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :rating
      t.text :comment
      t.boolean :verified_purchase, default: false
      t.datetime :approved_at
      t.boolean :featured, default: false

      t.timestamps
    end

    add_index :reviews, [:user_id, :product_id], unique: true
  end
end 