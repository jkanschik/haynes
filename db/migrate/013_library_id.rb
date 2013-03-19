class LibraryId < ActiveRecord::Migration
  def self.up
    execute "alter table libraries change id id int NOT NULL AUTO_INCREMENT"
  end

  def self.down
    execute "alter table libraries change id int NOT NULL AUTO_INCREMENT id "
  end
end
