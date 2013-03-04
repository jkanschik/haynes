class Instrument < ActiveRecord::Base
  has_many                :instruments_works
  has_and_belongs_to_many :works

end
