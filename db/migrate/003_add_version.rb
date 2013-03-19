class AddVersion < ActiveRecord::Migration
  def self.up
    Work.create_versioned_table
    LibrariesWork.create_versioned_table
    PublishersWork.create_versioned_table
    InstrumentationsWork.create_versioned_table
    Work.find(:all).each do |w|
      RAILS_DEFAULT_LOGGER.info "create version for #{w.id}"
      w.create_version
    end
  end

  def self.down
    Work.drop_versioned_table
    LibrariesWork.drop_versioned_table
    PublishersWork.drop_versioned_table
    InstrumentationsWork.drop_versioned_table
    Work.update_all "version = null"
  end
end
