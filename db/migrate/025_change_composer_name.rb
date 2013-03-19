class ChangeComposerName < ActiveRecord::Migration
  def self.up
    add_column :composers, :nick_name, :string
    add_column :composers, :affix_name, :string
  end

  def self.down
    remove_column :composers, :nick_name
    remove_column :composers, :affix_name
  end
end
