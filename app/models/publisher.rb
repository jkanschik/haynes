class Publisher < ActiveRecord::Base
  attr_accessible :label, :name, :city, :country_id, :www, :verlag_category, :comment_english, :done, :successor_id, :intern_info

  has_many :publishers_works
  has_and_belongs_to_many :works
  belongs_to  :successor, :class_name => "Publisher", :foreign_key => "successor_id"
  has_many    :predecessors, :class_name => "Publisher", :foreign_key => "successor_id"
  belongs_to  :country

  has_many    :documents,             :through => :document_usages
  has_many    :document_usages,       :as => :usage

  validates_presence_of :name, :label
  validates_uniqueness_of :label
end
