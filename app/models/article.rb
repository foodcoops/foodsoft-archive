class Article < ActiveRecord::Base
  belongs_to :supplier, touch: true
  belongs_to :article_category

  # an article can have many prices, but only one current price
  has_one :price, class_name: 'ArticlePrice'
  accepts_nested_attributes_for :price
  has_many :prices, -> { order('created_at DESC') }, class_name: 'ArticlePrice' # TODO destroy behaviour

  # always use latest price (can be changed when we'll support scheduled price changes)
  before_save { price = prices.first if price }

  default_scope -> { includes(:price) }

end
