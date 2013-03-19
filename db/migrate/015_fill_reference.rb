class FillReference < ActiveRecord::Migration
  def self.up
    lws = LibrariesWork.find(:all, :conditions => "library_id is null")
    lws.each do |lw|
      if lw.work && lw.work.done == 'N'
        Work.without_locking do
          Work.without_revision do
            lw.work.reference = (lw.work.reference || "") + lw.comment if lw.comment
            lw.work.save
          end
        end
        # Kommentier die folgende Zeile aus, wenn kein Löschen der LibraryWork gewünscht wird.
        # lw.destroy
      end
      say "Please check libraries_work with work_id = #{lw.work_id}, such a work doesn't exist." unless lw.work
    end
  end

  def self.down
  end
end
