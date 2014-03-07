ActiveAdmin.register Supplier do
  permit_params :stype, :name, :email, :address, :phone, :phone2, :fax, :url, :vat_number, :chamber_number, :logo

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
    div style: 'display: inline-block' do
      link_to admin_supplier_path(supplier) do
        if supplier.logo
          image_tag supplier.logo_url(:grid) 
        else
          # TODO placeholder
          div style: 'width: 30px; height: 30px;'
        end
      end
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

  sidebar "Logo", only: :show, if: Proc.new {supplier.logo} do
    image_tag supplier.logo_url, width: '100%' if supplier.logo
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

end
