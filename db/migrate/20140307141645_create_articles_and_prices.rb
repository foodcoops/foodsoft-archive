class CreateArticlesAndPrices < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :supplier_id, null: false
      t.string  :name,        null: false
      t.string  :order_number
      t.text    :description
      t.string  :manufacturer
      t.string  :origin
      t.string  :url
      t.string  :image
      t.integer :article_category_id
      t.integer :price_id

      t.timestamps
    end

    create_table :article_prices do |t|
      t.integer :article_id,                            null: false
      t.string  :unit,                                  null: false
      t.integer :unit_quantity,                         null: false, default: 1
      t.decimal :price,         precision: 8, scale: 2, null: false
      t.decimal :deposit,       precision: 8, scale: 2, null: false, default: 0
      t.decimal :tax,           precision: 3, scale: 1, null: false

      t.timestamps
    end

    create_table :article_categories do |t|
      t.string :name, null: false
      t.string :icon
      t.string :ancestry
      t.integer :position

      t.index :ancestry
    end
  end
end
