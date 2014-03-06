class Supplier < ActiveRecord::Base
  has_many :users, :dependent => :destroy

  validates_presence_of :name, :address, :phone

  geocoded_by :address
  after_validation :geocode, :if => Proc.new { self.address_changed? }
  
  #def articles_updated_at
  #  articles.order('articles.updated_on DESC').first.try(:updated_on)
  #end
end

# == Schema Information
#
# Table name: suppliers
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)     not null
#  address       :string(255)     not null
#  phone         :string(255)     not null
#  phone2        :string(255)
#  fax           :string(255)
#  email         :string(255)
#  url           :string(255)
#  delivery_days :string(255)
#  note          :string(255)
#  created_on    :datetime
#  updated_on    :datetime
#  lists         :string(255)
#  bnn_sync      :boolean(1)      default(FALSE)
#  bnn_host      :string(255)
#  bnn_user      :string(255)
#  bnn_password  :string(255)
#

