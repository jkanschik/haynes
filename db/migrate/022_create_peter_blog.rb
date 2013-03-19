class CreatePeterBlog < ActiveRecord::Migration
  def self.up
    create_table :blog, :force => true do |t|
      t.column :title,      :string
      t.column :content,    :text
      t.column :created_at, :timestamp
    end
  end

  def self.down
    drop_table :blog
  end
end
