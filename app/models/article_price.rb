class ArticlePrice < ActiveRecord::Base
  has_one :article, foreign_key: :price
  belongs_to :article

  # The financial gross, net plus tax and deposit.
  def gross_price
    ((price + deposit) * (tax / 100 + 1)).round(2)
  end

  # The price part which is tax
  def tax_price
    ((price + deposit) * tax / 100).round(2)
  end

end
