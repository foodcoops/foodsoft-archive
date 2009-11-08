class AddFlagsToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :flags, :integer, {:default => 0, :null => false}
  end

  def self.down
    remove_column :articles, :flags
  end
end
