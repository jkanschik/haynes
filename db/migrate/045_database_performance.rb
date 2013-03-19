class DatabasePerformance < ActiveRecord::Migration
  def self.up
    add_index :instrumentations_works, :instrumentation_id
    add_index :works, :composer_id
    add_index :works, :state
  end

  def self.down
  end
end
