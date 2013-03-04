class LibrariesWorkVersion < ActiveRecord::Base
  belongs_to  :work
  belongs_to  :libraries_work
  belongs_to  :library

  def comp_id
    "#{work_id};#{library_id}"
  end
end
