class CleanYears < ActiveRecord::Migration
  def self.up
    Work.find(:all).each do |w|
      w.year = nil if w.year == 99
      Work.without_locking do
        Work.without_revision do
          w.save
        end
      end
    end
  end
  
  def self.down
    Work.find(:all).each do |w|
      w.year = 99 if !w.year
      Work.without_locking do
        Work.without_revision do
          w.save
        end
      end
    end
  end
end