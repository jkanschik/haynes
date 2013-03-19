class AddDownloads < ActiveRecord::Migration
  def self.up
    create_table :materials, :force => true do |t|
      t.column :label,      :string
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
    
    Material.create!({:label => "Authograph"})
    Material.create!({:label => "Manuscript"})
    Material.create!({:label => "Early Print"})
    Material.create!({:label => "Facsimile"})
    Material.create!({:label => "Modern Edition"})
    Material.create!({:label => "Other"})

    create_table :downloads, :force => true do |t|
      t.column :kind,        :string
      t.column :material_id, :integer
      t.column :work_id,     :integer
      t.column :link,        :string
      t.column :comment,     :string
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end

  end

  def self.down
    drop_table :materials
    drop_table :downloads
  end
end
