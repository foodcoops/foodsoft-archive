ActiveAdmin.register ArticleCategory do
  permit_params :name, :description, :parent_id

  sortable tree: true, collapsible: true, nested_set: true

  index as: :sortable do
    label :name
    actions
  end

  filter :name
  filter :article_name

end
