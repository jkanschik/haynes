class WorkRelation < ActiveRecord::Base
  belongs_to :work
  belongs_to :related_work, :class_name => "Work", :foreign_key => "related_work_id"
end