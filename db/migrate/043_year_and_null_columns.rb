class YearAndNullColumns < ActiveRecord::Migration
  def self.up
     execute("update works set first_year = null and last_year = null where year <> null")
     
     change_column :works, :state,              :string, :default => "default", :null => false
     change_column :works, :title,              :string, :default => "", :null => false
     change_column :works, :main_title,         :string, :default => "", :null => false
     change_column :works, :tune,               :string, :default => "", :null => false
     change_column :works, :opus,               :string, :default => "", :null => false
     change_column :works, :instrumentation,    :string, :default => "", :null => false
     change_column :works, :published_place,    :string, :default => "", :null => false
     change_column :works, :published_time,     :string, :default => "", :null => false
     change_column :works, :misc_info,          :text, :default => "", :null => false
     change_column :works, :intern_info_peter,  :text, :default => "", :null => false
     change_column :works, :intern_info_bruce,  :text, :default => "", :null => false
     change_column :works, :done,               :string, :default => "N", :null => false, :limit => 1
     change_column :works, :published,          :text, :default => "", :null => false
     change_column :works, :position_title,     :string, :default => "", :null => false
     change_column :works, :oboe,               :string, :default => "NNNN", :null => false, :limit => 4
     change_column :works, :country,            :string, :default => "NNNNNNN", :null => false, :limit => 7
     
  end

  def self.down
  end
end
