# Old table "bese"
class Instrumentation < ActiveRecord::Base
  has_many                :instrumentations_works
  has_and_belongs_to_many :works
  belongs_to              :parent, :class_name => "Instrumentation", :foreign_key => :parent_id
  has_many                :children, :class_name => "Instrumentation", :foreign_key => :parent_id

  def id_as_text
    "#{(id / 10).to_s}.#{(id % 10).to_s}"
  end

end
