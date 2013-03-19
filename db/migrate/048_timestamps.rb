class Timestamps < ActiveRecord::Migration
  def self.up
    add_column :quotations, :updated_at, :datetime
    execute("update quotations set updated_at = changed_at")
    remove_column :quotations, :changed_at
    
    do_it "additions"
    do_it "codes"
    do_it "composers"
    do_it "composers_work_versions"
    do_it "composers_works"
    do_it "countries"
    do_it "instrumentations"
    do_it "instrumentations_work_versions"
    do_it "instrumentations_works"
    do_it "libraries"
    do_it "libraries_work_versions"
    do_it "libraries_works"
    do_it "publishers"
    do_it "publishers_work_versions"
    do_it "publishers_works"
    do_it "quotations"
    do_it "quotations_works"
    do_it "sources"
    do_it "users"
    do_it "version_comments"
    do_it "work_versions"
    do_it "works"
    
    execute "update users set state='default'"
    change_column :users, :role, :string, :default => "read_only", :null => false
    change_column :users, :state, :string, :default => "default", :null => false

    change_column :works, :state, :string, :default => "default", :null => false

  end

  def self.down
  end

  def self.do_it(table)
    execute("update #{table} set created_at='2004-06-17 00:00:00' where created_at is null")
    change_column table, :created_at, :datetime, :null => false

    execute("update #{table} set updated_at='2004-06-17 00:00:00' where updated_at is null")
    change_column table, :updated_at, :datetime, :null => false
  end

end
