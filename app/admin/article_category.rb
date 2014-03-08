ActiveAdmin.register ArticleCategory do
  permit_params :name, :description, :parent_id

  index do
    column :name
  end
end
