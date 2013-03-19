class VersionComments < ActiveRecord::Migration
  def self.up
    remove_column :works, :version_addition_id
    remove_column :work_versions, :version_addition_id
    add_column :work_versions, :addition_id, :integer
    add_column :work_versions, :version_comment_id, :integer
    create_table :version_comments, :force => true do |t|
      t.column :text,         :string
      t.column :created_at,   :timestamp
      t.column :updated_at,   :timestamp
    end
    VersionComment.create(:text => "Bruce changed after 1991")
    VersionComment.create(:text => "Peter Recherche")
    VersionComment.create(:text => "Someone else")
  end

  def self.down
    remove_column :work_versions, :version_comment_id
    remove_column :work_versions, :addition_id
    drop_table :version_comments
    add_column :works, :version_addition_id, :integer, :default => nil
    add_column :work_versions, :version_addition_id, :integer, :default => nil
  end
end
