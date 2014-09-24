ActiveAdmin.register Supplier do
  permit_params :stype, :name, :email, :address, :phone, :phone2, :fax, :url, :vat_number, :chamber_number, :logo
  decorate_with SupplierDecorator

  index as: :table do
    selectable_column
    column :logo, :logo_row
    column :name
    column :stype
    column :articles do |supplier|
      link_to supplier.articles.count, admin_articles_path(q: {supplier_id_eq: supplier.id})
    end
    column :email
    column :updated_at, sortable: :updated_at do |supplier|
      supplier.updated_at.to_date
    end
    actions
  end

  index as: :map

  index as: :grid do |supplier|
    div style: 'display: inline-block' do
      link_to supplier.logo_grid, admin_supplier_path(supplier)
    end
  end

  filter :stype, as: :select
  filter :name
  filter :email
  filter :updated_at

  show title: Proc.new {|s| "#{s.name} (#{s.stype})"} do
    attributes_table do
      row :id
      row :name
      row :stype
      row :email
      row :address
      row :phone
      row :phone2
      row :fax
      row :url
      row :vat_number
      row :chamber_number
      row :created_at
      row :updated_at
    end
  end

  sidebar "Logo", only: :show, if: Proc.new {supplier.logo.present?} do
    image_tag supplier.logo_url, width: '100%'
  end

  sidebar "Map", only: :show, if: Proc.new {supplier.latitude and supplier.longitude} do
    render 'shared/map', objects: [supplier], width: '243px', height: '243px', zoom: 9
  end

  form do |f|
    f.inputs 'General' do
      f.input :name
      f.input :stype
    end
    f.inputs 'Contact' do
      f.input :email
      f.input :address
      f.input :phone
      f.input :phone2
      f.input :fax
      f.input :url
      f.input :vat_number
      f.input :chamber_number
    end
    f.inputs 'Artwork' do
      f.input :logo, as: :file
    end
    f.actions
  end

  # @todo make this work with geocoder
  active_admin_import validate: true, timestamps: true, back: :admin_suppliers, template: 'admin/import_supplier'

end
