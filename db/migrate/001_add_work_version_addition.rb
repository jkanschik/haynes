class AddWorkVersionAddition < ActiveRecord::Migration
  def self.up
    add_column :works, :version_addition_id, :integer, :default => nil
  end

  def self.down
    remove_column :works, :version_addition_id
  end
end
