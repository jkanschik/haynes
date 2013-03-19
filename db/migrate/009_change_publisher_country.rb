class ChangePublisherCountry < ActiveRecord::Migration
  def self.up
    rename_column :publishers, :country, :country_old
    add_column :publishers, :country_id, :integer
    Publisher.reset_column_information
    Publisher.find(:all).each do |p|
      c = Country.find_by_code(p.country_old.strip) if p.country_old
      if c
        puts "Selected country #{c.id}, code #{c.code} for publisher #{p.id}, which has country old '#{p.country_old}'"
        p.update_attribute "country_id", c.id
      else
        puts "No country for publisher #{p.id}, which has country old '#{p.country_old}'"
      end
    end
  end

  def self.down
    rename_column :publishers, :country_old, :country
    remove_column :publishers, :country_id
  end
end
