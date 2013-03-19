class RemoveWorkId0 < ActiveRecord::Migration
  def self.up
    InstrumentationsWork.delete_all "work_id=0"
    LibrariesWork.delete_all "work_id=0"
    PublishersWork.delete_all "work_id=0"
  end

  def self.down
  end
end
