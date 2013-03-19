class CleanPubComments < ActiveRecord::Migration
  def self.up
    PublishersWork.find(:all).each do |pw|
      if pw.comment 
        pw.comment.strip! # remove whitespace (space, line break, tabulator)
        pw.comment.sub!(/^\((.*)\)$/,'\1') # remove ()
        pw.comment.sub!(/^\((.*)\)\.$/,'\1') # remove ()
      end
      
      # remove silly &nbsp; and () from database.
      PublishersWork.without_locking do
        PublishersWork.without_revision do
          pw.save
        end
      end
    end
  end

  def self.down
    # no sense in undoing this!
  end
end
