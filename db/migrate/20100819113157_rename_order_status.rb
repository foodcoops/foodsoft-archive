class RenameOrderStatus < ActiveRecord::Migration
  def self.up

    Order.after_update.clear # Avoid heafy callbacks, saves time.

    say_with_time "Rename order states .." do
      Order.all.each do |order|
        order.state = case order.state
        when 'open' then 'started'
        when 'finished' then 'closed'
        when 'closed' then 'balanced'
        end
        order.save!
      end
    end
    change_column :orders, :state, :string, :default => 'started'
  end

  def self.down
  end
end
