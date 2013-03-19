class ChangeSourceId < ActiveRecord::Migration
  def self.up
    change_column :works, :source_id, :integer, :default => 3, :null => false
  end

  def self.down
    change_column :works, :source_id, :integer, :default => 1, :null => false
  end
end
