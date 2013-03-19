class CleanUpOldTables < ActiveRecord::Migration
  def self.up
    # drop old table libr
    drop_table :libr
    
    # remove old columns in works/work_versions
    remove_column :works, :modausgabe
    remove_column :works, :modausgabeDROP
    remove_column :works, :anmerkungDROP
    remove_column :work_versions, :modausgabe
    remove_column :work_versions, :modausgabeDROP
    remove_column :work_versions, :anmerkungDROP
    
    # create new column reference in works/work_versions
    add_column :works, :reference, :string
    add_column :work_versions, :reference, :string
    
    works = Work.find(:all, :conditions => 'composer_id = 19')
    works.each do |w|
      w.attr_doubtful = 'Y'
      w.save
    end
  end

  def self.down
    # the changes in "up" can't not be reversed => raise an exception
    raise ActiveRecord::IrreversibleMigration.new
  end
end
