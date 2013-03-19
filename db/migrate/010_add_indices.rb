class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :works, :id, :unique => true
    add_index :composers, :id, :unique => true
    add_index :libraries, :id, :unique => true
    add_index :publishers, :id, :unique => true
    add_index :instrumentations, :id, :unique => true
    add_index :libraries_works, :work_id
    add_index :publishers_works, :work_id
    add_index :instrumentations_works, :work_id
    add_index :libraries_work_versions, :work_id
    add_index :publishers_work_versions, :work_id
    add_index :instrumentations_work_versions, :work_id
  end

  def self.down
    remove_index :works, :id
    remove_index :composers, :id
    remove_index :libraries, :id
    remove_index :publishers, :id
    remove_index :instrumentations, :id
    remove_index :libraries_works, :work_id
    remove_index :publishers_works, :work_id
    remove_index :instrumentations_works, :work_id
    remove_index :libraries_work_versions, :work_id
    remove_index :publishers_work_versions, :work_id
    remove_index :instrumentations_work_versions, :work_id
  end
end
