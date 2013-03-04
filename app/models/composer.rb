class Composer < ActiveRecord::Base
  has_many    :works
  has_many    :active_works, :class_name => "Work", :conditions => "works.state = 'default'"
  has_many    :alias, :dependent => :destroy

  has_many    :documents,             :through => :document_usages
  has_many    :document_usages,       :as => :usage
  
  validates_presence_of :name, :message => "Missing field"
  
  def validate
    if id
      conditions = ['id <> ? and name = ? and first_name = ?', id, name, first_name]
    else
      conditions = ['name = ? and first_name = ?', name, first_name]
    end
    if Composer.exists? conditions
      errors.add("name", "A composer with this name and first name already exists")
      errors.add("first_name", "A composer with this name and first name already exists")
    end
    if life_info != "" and (born or dead)
      errors.add("life_info", "Please enter either 'life_info' or 'born/dead', but not both.")
    end
  end

  def full_name
    if first_name.nil? || first_name == ""
      return name
    else
      return name + ', ' + first_name
    end
  end
  
end
