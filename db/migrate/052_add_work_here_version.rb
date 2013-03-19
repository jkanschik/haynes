class AddWorkHereVersion < ActiveRecord::Migration
  def self.up
    add_column :work_versions, :here, :boolean, :default => false
  end

  def self.down
    remove_column :work_versions, :here
  end
end
