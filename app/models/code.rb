class Code < ActiveRecord::Base

  def self.by_context(context)
    where("context like '#{context}_'")
#    find(:all, :conditions => ["locate(context, ?) = 1", context])
  end

  def self.by_code_and_context(code, context)
    where(code: code).by_context(context)
#    find :first, :conditions => ["code = ? and locate(context, ?) = 1", c, context]
  end

end
