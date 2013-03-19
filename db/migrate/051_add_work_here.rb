class AddWorkHere < ActiveRecord::Migration
  def self.up
    add_column :works, :here, :boolean, :default => false
  end

  def self.down
    remove_column :works, :here
  end
end
