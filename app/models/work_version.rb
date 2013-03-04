class WorkVersion < ActiveRecord::Base
  belongs_to  :work
  belongs_to  :version_comment
  belongs_to  :addition
end
