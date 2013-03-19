class ChangeLost < ActiveRecord::Migration
  def self.up
    wpart = Work.find(:all, :conditions => "intern_info_peter like '%#part#%'")
    wpart.each do |lw|
        Work.without_locking do
          Work.without_revision do
            say "Setze lost auf 'P' für Werk #{lw.id}."
            lw.intern_info_peter.gsub!("#part#", "")
            lw.lost = "P"
            lw.save
          end
        end
    end
  end

  def self.down
  end
end
