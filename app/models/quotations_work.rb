class QuotationsWork < ActiveRecord::Base
  belongs_to :work
  belongs_to :quotation
end
