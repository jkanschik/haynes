class NormalizeComposers < ActiveRecord::Migration
  def self.up
    change_column :composers, :alt_name, :string, :default => "", :null => false
    change_column :composers, :first_name, :string, :default => "", :null => false
    change_column :composers, :alt_first_name, :string, :default => "", :null => false
    change_column :composers, :info_born, :string, :default => "", :null => false
    change_column :composers, :info_dead, :string, :default => "", :null => false
    change_column :composers, :nick_name, :string, :default => "", :null => false
    change_column :composers, :affix_name, :string, :default => "", :null => false
    
    Composer.find(:all, :conditions => "born = 0 or dead = 0").each do |composer|
      say "Setting born/dead to NULL for composer #{composer.id}."
      composer.born = nil if composer.born == 0
      composer.dead = nil if composer.dead == 0
      composer.save!
    end
       
  end

  def self.down
  end
end
