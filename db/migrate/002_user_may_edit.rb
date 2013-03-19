class UserMayEdit < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string, :default => 'read_only'

    user = User.find_by_logname 'jkanschik'
    user.update_attribute(:role, 'admin')

    user = User.find_by_logname 'pdq'
    user.update_attribute(:role, 'admin')

    user = User.find_by_logname 'master'
    user.update_attribute(:role, 'admin')
  end

  def self.down
    remove_column :users, :role
  end
end
