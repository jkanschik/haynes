class Additions < ActiveRecord::Migration
  def self.up
    change_column :additions, :state,              :string, :default => "new", :null => false
  end

  def self.down
  end
end
