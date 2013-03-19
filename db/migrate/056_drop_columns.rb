class DropColumns < ActiveRecord::Migration
  def self.up
    drop_table :blogs
    drop_table :generations
    drop_table :decades
    
    remove_column :publishers, :country_old
    remove_column :libraries, :labelDROP
    
    remove_column :works, :generation_id
    remove_column :works, :decade_id
    remove_column :works, :hits
    remove_column :works, :incipit_useful
    remove_column :works, :reference
    remove_column :works, :published_place
    remove_column :works, :published_time
    
    remove_column :work_versions, :generation_id
    remove_column :work_versions, :decade_id
    remove_column :work_versions, :hits
    remove_column :work_versions, :incipit_useful
    remove_column :work_versions, :reference
    remove_column :work_versions, :published_place
    remove_column :work_versions, :published_time
  end  

  def self.down
  end
end
