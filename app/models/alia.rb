class Alia < ActiveRecord::Base
  self.table_name="alias"
  belongs_to :composer
end
