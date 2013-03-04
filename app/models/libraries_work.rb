class LibrariesWork < ActiveRecord::Base

  belongs_to :work
  belongs_to :library

  acts_as_versioned :association_options => {:dependent   => :nullify}
  
  def comp_id
    "#{work_id};#{library_id}"
  end

  protected
    # Gets the next available version for the current record, or 1 for a new record
    def next_version
      work.next_version
    end

end
