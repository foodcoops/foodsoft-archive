class RenameOrderStatus < ActiveRecord::Migration
  def self.up
    Order.all.each do |order|
      order.state = case order.state
      when 'open' then 'started'
#      when 'finished' then 'finished'
      when 'closed' then 'balanced'
      end
      order.save!
    end

    change_column :orders, :state, :string, :default => 'started'
  end

  def self.down
  end
end
