class ChangeAdditionState < ActiveRecord::Migration
  def self.up
    Addition.find(:all).each { |a| a.update_attributes({:state => "new"}) }
  end

  def self.down
  end
end
