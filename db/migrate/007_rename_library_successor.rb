class RenameLibrarySuccessor < ActiveRecord::Migration
  def self.up
    rename_column :libraries, :successor, :successor_id
  end

  def self.down
    rename_column :libraries, :successor_id, :successor
  end
end
