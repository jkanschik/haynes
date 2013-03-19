class ConvertPublished < ActiveRecord::Migration
  def self.up
    add_column :works, :published, :text
    execute "update works set published = concat_ws(' ', published_place, published_time)"
  end

  def self.down
    remove_column :works, :published
  end
end
