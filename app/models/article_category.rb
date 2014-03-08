class ArticleCategory < ActiveRecord::Base

  has_many :articles

  # awesome_nested_set
  acts_as_nested_set
  default_scope -> { order('lft ASC') }

end
