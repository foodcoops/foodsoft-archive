# == Schema Information
#
# Table name: suppliers
#
#  id                 :integer         not null, primary key
#  name               :string(255)     default(""), not null
#  address            :string(255)     default(""), not null
#  phone              :string(255)     default(""), not null
#  phone2             :string(255)
#  fax                :string(255)
#  email              :string(255)
#  url                :string(255)
#  contact_person     :string(255)
#  customer_number    :string(255)
#  delivery_days      :string(255)
#  order_howto        :string(255)
#  note               :string(255)
#  shared_supplier_id :integer
#  min_order_quantity :string(255)
#  deleted_at         :datetime
#

class Supplier < ActiveRecord::Base
  acts_as_paranoid  # Avoid deleting the supplier for consistency of order-results

  has_many :articles, :dependent => :destroy, :conditions => {:type => nil},
    :include => [:article_category], :order => 'article_categories.name, articles.name'
  has_many :stock_articles, :include => [:article_category], :order => 'article_categories.name, articles.name'
  has_many :orders
  has_many :deliveries
  has_many :invoices
  belongs_to :shared_supplier  # for the sharedLists-App

  attr_accessible :name, :address, :phone, :phone2, :fax, :email, :url, :contact_person, :customer_number, :delivery_days, :order_howto, :note, :shared_supplier_id, :min_order_quantity
	
  validates_length_of :name, :in => 4..30
  validates_uniqueness_of :name

  validates_length_of :phone, :in => 8..20
  validates_length_of :address, :in => 8..50

  # sync all articles with the external database
  # returns an array with articles(and prices), which should be updated (to use in a form)
  # also returns an array with outlisted_articles, which should be deleted
  def sync_all
    updated_articles = Array.new
    outlisted_articles = Array.new
    for article in articles.without_deleted
      # try to find the associated shared_article
      shared_article = article.shared_article

      if shared_article # article will be updated
        
        unequal_attributes = article.shared_article_changed?
        unless unequal_attributes.blank? # skip if shared_article has not been changed
          
          # try to convert different units
          new_price, new_unit_quantity = article.convert_units
          if new_price and new_unit_quantity
            article.price = new_price
            article.unit_quantity = new_unit_quantity
          else
            article.price = shared_article.price
            article.unit_quantity = shared_article.unit_quantity
            article.unit = shared_article.unit
          end
          # update other attributes
          article.attributes = {
            :name => shared_article.name,
            :manufacturer => shared_article.manufacturer,
            :origin => shared_article.origin,
            :shared_updated_on => shared_article.updated_on,
            :tax => shared_article.tax,
            :deposit => shared_article.deposit,
            :note => shared_article.note
          }
          updated_articles << [article, unequal_attributes]
        end
      else
        # article isn't in external database anymore
        outlisted_articles << article
      end
    end
    return [updated_articles, outlisted_articles]
  end
end
