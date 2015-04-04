class ArticleCategory < ActiveRecord::Base
  has_ancestry
  acts_as_list scope: [:ancestry]

  has_many :articles

end
