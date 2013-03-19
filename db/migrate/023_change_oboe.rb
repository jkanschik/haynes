class ChangeOboe < ActiveRecord::Migration
  def self.up
    add_column :works, :oboe_done, :string, :default => 'N' 
  end

  def self.down
    remove_column :works, :oboe_done
  end
end
