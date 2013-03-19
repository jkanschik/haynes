class ChangeCreatedAt < ActiveRecord::Migration
  def self.up
    change_column :works, "country", :string, :limit => 7, :default => 'NNNNNNN', :null => false

    change_column :works, "created_at", :timestamp
    change_column :work_versions, "created_at", :timestamp

    add_column :countries, :created_at, :timestamp
    add_column :generations, :created_at, :timestamp
    add_column :instrumentations, :created_at, :timestamp
    add_column :instrumentations_works, :created_at, :timestamp
    add_column :instrumentations_work_versions, :created_at, :timestamp
    add_column :libraries, :created_at, :timestamp
    add_column :libraries_works, :created_at, :timestamp
    add_column :libraries_work_versions, :created_at, :timestamp
    add_column :publishers, :created_at, :timestamp
    add_column :publishers_works, :created_at, :timestamp
    add_column :publishers_work_versions, :created_at, :timestamp
    add_column :sources, :created_at, :timestamp
    add_column :users, :created_at, :timestamp

    add_column :countries, :updated_at, :timestamp
    add_column :generations, :updated_at, :timestamp
    add_column :instrumentations, :updated_at, :timestamp
    add_column :instrumentations_works, :updated_at, :timestamp
    add_column :libraries, :updated_at, :timestamp
    add_column :libraries_works, :updated_at, :timestamp
    add_column :publishers, :updated_at, :timestamp
    add_column :publishers_works, :updated_at, :timestamp
    add_column :sources, :updated_at, :timestamp
    add_column :users, :updated_at, :timestamp
  end

  def self.down
    change_column :works, "country", :string, :limit => 7

    change_column :works, "created_at", :date, :default => '2004-06-17', :null => false
    change_column :work_versions, "created_at", :date, :default => '2004-06-17', :null => false

    remove_column :countries, :created_at
    remove_column :generations, :created_at
    remove_column :instrumentations, :created_at
    remove_column :instrumentations_works, :created_at
    remove_column :instrumentations_work_versions, :created_at
    remove_column :libraries, :created_at
    remove_column :libraries_works, :created_at
    remove_column :libraries_work_versions, :created_at
    remove_column :publishers, :created_at
    remove_column :publishers_works, :created_at
    remove_column :publishers_work_versions, :created_at
    remove_column :sources, :created_at
    remove_column :users, :created_at

    remove_column :countries, :updated_at
    remove_column :generations, :updated_at
    remove_column :instrumentations, :updated_at
    remove_column :instrumentations_works, :updated_at
    remove_column :libraries, :updated_at
    remove_column :libraries_works, :updated_at
    remove_column :publishers, :updated_at
    remove_column :publishers_works, :updated_at
    remove_column :sources, :updated_at
    remove_column :users, :updated_at
  end
end
