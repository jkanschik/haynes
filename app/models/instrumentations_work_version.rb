class InstrumentationsWorkVersion < ActiveRecord::Base
  belongs_to  :work
  belongs_to  :instrumentations_work
  belongs_to  :instrumentation

  def comp_id
    "#{work_id};#{instrumentation_id}"
  end
end
