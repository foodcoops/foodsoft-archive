class ArticlePrice < ActiveRecord::Base
  has_one :article, foreign_key: :price
  belongs_to :article
end
