class CreateSupplier < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name,          null: false
      t.string :stype
      t.string :email,         null: false
      t.string :address,       null: false
      t.string :latitude
      t.string :longitude
      t.string :phone,         null: false
      t.string :phone2
      t.string :fax
      t.string :url
      t.string :vat_number
      t.string :chamber_number
      t.datetime :created_at,  null: false
      t.datetime :updated_at,  null: false
    end

    create_table :supplier_conditions do |t|
      t.integer :supplier_id,                                null: false
      t.decimal :min_order_net,      precision: 8, scale: 2
      t.decimal :min_order_gross,    precision: 8, scale: 2
      t.integer :min_order_articles
      t.decimal :fee_flat,           precision: 8, scale: 2
      t.float   :fee_margin
    end
  end
end
