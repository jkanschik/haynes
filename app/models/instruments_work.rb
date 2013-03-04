class InstrumentsWork < ActiveRecord::Base
  belongs_to :work
  belongs_to :instrument

end
