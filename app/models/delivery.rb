# == Schema Information
#
# Table name: deliveries
#
#  id           :integer         not null, primary key
#  supplier_id  :integer
#  delivered_on :date
#  created_at   :datetime
#

class Delivery < ActiveRecord::Base

  belongs_to :supplier
  has_one :invoice
  has_many :stock_changes, :dependent => :destroy

  named_scope :recent, :order => 'created_at DESC', :limit => 10

  validates_presence_of :supplier_id

  accepts_nested_attributes_for :stock_changes, :allow_destroy => :true

  def new_stock_changes=(stock_change_attributes)
    for attributes in stock_change_attributes
      stock_changes.build(attributes) unless attributes[:quantity].to_i == 0
    end
  end
  
end
