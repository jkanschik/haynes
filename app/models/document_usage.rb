class DocumentUsage < ActiveRecord::Base
  belongs_to  :usage,     :polymorphic => true
  belongs_to  :document,  :dependent => :destroy
  
  belongs_to  :work,      :foreign_key => 'usage_id', 
                          :class_name => 'Work'
  belongs_to  :composer,  :foreign_key => 'usage_id', 
                          :class_name => 'Composer'
  belongs_to  :publisher, :foreign_key => 'usage_id', 
                          :class_name => 'Publisher'
  belongs_to  :library,   :foreign_key => 'usage_id', 
                          :class_name => 'Library'
end
