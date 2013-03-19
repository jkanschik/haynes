class FixAdditions < ActiveRecord::Migration
  def self.up
    change_column :additions, :created_at, :datetime, :default => nil
    change_column :users, :created_at, :datetime, :default => nil
  end  

  def self.down
    change_column :additions, :created_at, :datetime, :null => false, :default => '2004-06-17 00:00:00'
    change_column :users, :created_at, :datetime, :null => false, :default => '2004-06-17 00:00:00'
  end
end
