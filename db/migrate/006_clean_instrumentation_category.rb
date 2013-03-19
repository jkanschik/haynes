class CleanInstrumentationCategory < ActiveRecord::Migration
  def self.up
    Instrumentation.find(:all).each do |i|
      i.category.chomp! # remove silly \r\n from database.
      i.save
    end
  end

  def self.down
    Instrumentation.find(:all).each do |i|
      i.category += "\r\n" # add silly \r\n from database.
      i.save
    end
  end
end
