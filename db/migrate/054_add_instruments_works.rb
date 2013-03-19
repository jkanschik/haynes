class AddInstrumentsWorks < ActiveRecord::Migration
  def self.up
    create_table :instruments_works, :force => true do |t|
      t.column :work_id,        :integer
      t.column :instrument_id,  :integer
      t.column :occurences,     :integer, :default => 1
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime, :null => false
    end
  end  

  def self.down
    drop_table :instruments_works
  end
end
