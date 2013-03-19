class ChangePublisher< ActiveRecord::Migration
  def self.up
      rename_column :publishers, :verlag_bez_old,       :name
  end

  def self.down
      rename_table :publishers, :name,       :verlag_bez_old
  end
end
