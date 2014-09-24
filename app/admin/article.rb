ActiveAdmin.register Article do
  permit_params :supplier_id, :name, :order_number, :description, :manufacturer, :origin, :url, :image,
    :article_category_id, price_attributes: [:unit, :unit_quantity, :price, :deposit, :tax]
  decorate_with ArticleDecorator

  controller do
    def scoped_collection
      resource_class.includes(:price, :article_category, :supplier)
    end
  end

  index as: :table do
    selectable_column
    column 'Nr', :order_number
    column :name
    column :article_category
    column :unit, sortable: 'price.unit, price.unit_quantity'
    column :supplier
    column :manufacturer
    column :price, sortable: 'price.price'
    column :updated_at
    actions
  end
 
  filter :supplier, as: :select
  filter :article_category
  filter :name
  filter :order_number
  filter :price_price, as: :numeric, label: 'net price'
  filter :manufacturer
  filter :origin
  filter :url, as: :boolean
  filter :image, as: :boolean


  show title: Proc.new {|s| "#{s.name} (#{s.supplier.name})"} do
    attributes_table do
      row :id
      row :supplier
      row :order_number
      row :name
      row :article_category
      row :description
      row :unit
      row :price
      row :supplier
      row :manufacturer
      row :origin
      row :url
      row :created_at
      row :updated_at
    end
  end


  form do |f|
    f.inputs 'General' do
      f.input :supplier
      f.input :order_number
      f.input :name
      f.input :article_category
      f.input :description, input_html: { rows: 3 }
    end
    f.inputs 'Price', for: [:price, f.object.price || ArticlePrice.new] do |p|
      p.input :unit_quantity
      p.input :unit
      p.input :price
      p.input :tax
      p.input :deposit
    end
    f.inputs 'Details' do
      f.input :manufacturer
      f.input :origin
      f.input :url
    end
    f.actions
  end
 
  active_admin_import validate: true, timestamps: true, back: :admin_articles, template: 'admin/import_article'

end
