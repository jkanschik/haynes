class ChangeBlog< ActiveRecord::Migration
  def self.up
      rename_table :blog,       :blogs
  end

  def self.down
      rename_table :blogs,       :blog
  end
end
