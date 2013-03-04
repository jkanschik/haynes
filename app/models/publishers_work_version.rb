class PublishersWorkVersion < ActiveRecord::Base
  belongs_to  :work
  belongs_to  :publishers_work
  belongs_to  :publisher

  def comp_id
    "#{work_id};#{publisher_id}"
  end
end
