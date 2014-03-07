ActiveAdmin.register Supplier do
  permit_params :stype, :name, :email, :address, :phone, :phone2, :fax, :url, :vat_number, :chamber_number

  index as: :table do
    selectable_column
    column :name
    column :stype
    column :address
    column :email
    column :created_at
    actions
  end
  index as: :map
  index as: :grid do |supplier|
    link_to admin_supplier_path(supplier) do
      image_tag nil
      div supplier.name
    end
  end

  filter :stype, as: :select
  filter :name
  filter :email
  filter :created_at

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

  sidebar "Map", only: :show do
    if supplier.latitude and supplier.longitude
      div do
        render 'shared/map', objects: [supplier], width: '243px', height: '243px', zoom: 9
      end
    end
  end

end
