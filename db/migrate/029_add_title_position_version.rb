class AddTitlePositionVersion< ActiveRecord::Migration
  def self.up
    add_column :work_versions, :position_title, :string
  end

  def self.down
    remove_column :work_versions, :position_title
  end
end
