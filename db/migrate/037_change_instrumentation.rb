class ChangeInstrumentation < ActiveRecord::Migration
  def self.up
    add_column    :instrumentations, :parent_id, :integer
    Instrumentation.find(:all).each do |i|
      i.parent_id = (i.category == "body" ? 10*(i.id/10) : nil)
      i.code = i.id_as_text
      i.save!
    end
    rename_column :instrumentations, :category, :category_drop
  end

  def self.down
    remove_column :instrumentations, :parent_id
    rename_column :instrumentations, :category_drop, :category
  end
end
