class AddTimestamps < ActiveRecord::Migration
  @updated_at = [:abbreviations, :alias, :blogs, :decades, :document_usages, :documents, :work_relations]
  @created_at = [:abbreviations, :alias, :decades, :document_usages, :documents, :work_relations]
  @updated_at_default = [
    :additions, :codes, :composers, :composers_work_versions, :composers_works, :countries, :downloads, 
    :generations, :instrumentations, :instrumentations_work_versions, :instrumentations_works,
    :libraries, :libraries_work_versions, :libraries_works, :materials, :problems,
    :publishers, :publishers_work_versions, :publishers_works, 
    :quotations, :quotations_works, :sources, :users, :version_comments, :work_versions, :works
    ]
  @created_at_default = [:additions, :blogs, :codes, :composers, :composers_work_versions, :composers_works, :countries, :downloads, 
    :generations, :instrumentations, :instrumentations_work_versions, :instrumentations_works,
    :libraries, :libraries_work_versions, :libraries_works, :materials, :problems,
    :publishers, :publishers_work_versions, :publishers_works, 
    :quotations, :quotations_works, :sources, :users, :version_comments, :works
    ]

  def self.up
    @updated_at.each {|table| add_column table, :updated_at, :datetime, :null => false, :default => '2004-06-17 00:00:00'}
    @created_at.each {|table| add_column table, :created_at, :datetime, :null => false, :default => '2004-06-17 00:00:00'}

    @updated_at_default.each {|table| 
      change_column table, :updated_at, :datetime, :null => false, :default => '2004-06-17 00:00:00'
      klazz = Kernel.const_get(table.to_s.classify())
      klazz.update_all("updated_at = '2004-06-17 00:00:00'", "updated_at is null")
    }
    @created_at_default.each {|table|
      change_column table, :created_at, :datetime, :null => false, :default => '2004-06-17 00:00:00'
      klazz = Kernel.const_get(table.to_s.classify())
      klazz.update_all("created_at = '2004-06-17 00:00:00'", "created_at is null")
    }
  end

  def self.down
    @updated_at.each {|table| remove_column table, :updated_at}
    @updated_at_default.each {|table| change_column table, :updated_at, :datetime, :null => false}
    @created_at.each {|table| remove_column table, :created_at}
    @created_at_default.each {|table| change_column table, :created_at, :datetime, :null => false}
  end

end
