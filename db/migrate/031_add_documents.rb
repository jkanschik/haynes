class AddDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents, :force => true do |t|
      t.column :code,       :string
      t.column :title,      :string
      t.column :info,       :text
    end
    create_table :document_usages, :force => true do |t|
      t.column :document_id,  :integer
      t.column :usage_id,     :integer
      t.column :usage_type,   :string
    end
  end

  def self.down
    drop_table :documents
    drop_table :document_usages
  end
end
