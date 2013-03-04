class ComposersWorkVersion < ActiveRecord::Base
  belongs_to  :work
  belongs_to  :composers_work
  belongs_to  :composer

  def comp_id
    "#{work_id};#{composer_id}"
  end
end
