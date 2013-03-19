class IncreaseOpus < ActiveRecord::Migration
  def self.up
    change_column :works, "opus", :string
    change_column :work_versions, "opus", :string
  end

  def self.down
    change_column :works, "opus", :string, :limit => 60
    change_column :work_versions, "opus", :string, :limit => 60
  end
end
