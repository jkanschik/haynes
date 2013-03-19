class AddTitlePosition < ActiveRecord::Migration
  def self.up
    add_column :works, :position_title, :string
  end

  def self.down
    remove_column :works, :position_title
  end
end
