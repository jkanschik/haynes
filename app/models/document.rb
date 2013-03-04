class Document < ActiveRecord::Base
  has_many :document_usages,  :dependent => :destroy
  has_many :works,            :through => :document_usages, :source => :work, 
                              :conditions => "document_usages.usage_type = 'Work'"
  has_many :composers,        :through => :document_usages, :source => :composer, 
                              :conditions => "document_usages.usage_type = 'Composer'"
  has_many :publishers,       :through => :document_usages, :source => :publisher, 
                              :conditions => "document_usages.usage_type = 'Publisher'"
  has_many :libraries,        :through => :document_usages, :source => :library, 
                              :conditions => "document_usages.usage_type = 'Library'"
end
