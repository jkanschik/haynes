class Library < ActiveRecord::Base

  has_many :libraries_works
  has_and_belongs_to_many :works
  belongs_to  :country
  belongs_to  :successor, :class_name => "Library", :foreign_key => "successor_id"
  has_many    :predecessors, :class_name => "Library", :foreign_key => "successor_id"
  
  has_many    :documents,             :through => :document_usages
  has_many    :document_usages,       :as => :usage

  validates_presence_of :country, :name, :label, :code_place, :message => "Missing field"

  def validate
    if id
      conditions = ['id <> ? and country_id = ? and code_place = ?', id, country_id, code_place]
    else
      conditions = ['country_id = ? and code_place = ?', country_id, code_place]
    end
    if Library.exists? conditions
      errors.add("country_id", "A library with this country and code_place already exists")
      errors.add("code_place", "A library with this country and code_place already exists")
    end
  end
  
  def nice_label
    country_code = country.nil? ? nil : country.code
    (country_code || '??') + "-" + (code_place || '??')
  end
end
