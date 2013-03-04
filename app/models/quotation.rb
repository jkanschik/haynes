class Quotation < ActiveRecord::Base
  has_many :quotations_works
  has_and_belongs_to_many :works
  
  validates_presence_of :label, :title, :message => "Missing field"
  validates_uniqueness_of :label
end
