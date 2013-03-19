class AddAltcomposercategory < ActiveRecord::Migration
  def self.up
    add_column :composers_works, :category, :string, :default => 'also attributed to'
    add_column :composers_work_versions, :category, :string, :default => 'also attributed to'
  end

  def self.down
    remove_column :composers_works, :category
    remove_column :composers_work_versions, :category
  end
end
