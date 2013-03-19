class Semikolon < ActiveRecord::Migration
  def self.up
    Composer.find(:all).each do |c|
      c.misc_info.gsub!("Semikolon", ";")
      c.save!
    end
  end

  def self.down
  end
end
