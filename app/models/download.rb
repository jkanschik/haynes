class Download < ActiveRecord::Base
  belongs_to :material
  belongs_to :work
end
