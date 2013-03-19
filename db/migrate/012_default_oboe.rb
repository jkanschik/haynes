class DefaultOboe < ActiveRecord::Migration
  def self.up
    change_column :works, "oboe", :string, :limit => 4, :default => 'NNNN', :null => false
  end

  def self.down
    change_column :works, "oboe", :string, :limit => 4
  end
end
