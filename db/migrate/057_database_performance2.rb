class DatabasePerformance2 < ActiveRecord::Migration
  def self.up
    add_index :work_versions, :work_id
    add_index :composers_work_versions, :work_id
    add_index :composers_works, :work_id
    add_index :quotations_works, :work_id
    add_index :additions, :work_id
    add_index :alias, :composer_id
    add_index :work_relations, :work_id
    
  end

  def self.down
    remove_index :work_versions, :work_id
    remove_index :composers_work_versions, :work_id
    remove_index :composers_works, :work_id
    remove_index :quotations_works, :work_id
    remove_index :additions, :work_id
    remove_index :alias, :composer_id
    remove_index :work_relations, :work_id
  end
end
