class Addition < ActiveRecord::Base
  belongs_to  :work
  belongs_to  :user
  has_many    :work_versions

  validates_presence_of     :text,     :message => "Please enter the comment or cancel."
end
