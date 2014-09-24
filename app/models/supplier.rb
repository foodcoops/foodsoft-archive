class Supplier < ActiveRecord::Base

  #has_many :users, :dependent => :destroy

  validates_presence_of :name, :email, :address, :phone

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  mount_uploader :logo, ImageUploader

  has_many :articles

end
