class Year < ActiveRecord::Migration
  def self.up
     execute("update works set first_year = null, last_year = null where year is not null")
     
  end

  def self.down
  end
end
