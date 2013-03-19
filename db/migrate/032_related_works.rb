class RelatedWorks < ActiveRecord::Migration
  def self.up
    create_table :work_relations, :force => true do |t|
      t.column :work_id,              :integer
      t.column :related_work_id,      :integer
    end

  end

  def self.down
    drop_table :work_relations
  end
end
