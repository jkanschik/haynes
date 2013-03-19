class FixPublishedVersions < ActiveRecord::Migration
  def self.up
    add_column :work_versions, :published, :text
    add_column :work_versions, :year, :integer
    add_column :work_versions, :first_year, :integer
    add_column :work_versions, :last_year, :integer
    add_column :work_versions, :oboe_done, :string
  end

  def self.down
    remove_column :work_versions, :published
    remove_column :work_versions, :year
    remove_column :work_versions, :first_year
    remove_column :work_versions, :last_year
    remove_column :work_versions, :oboe_done
  end
end
