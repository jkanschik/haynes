class ChangeCodeTable < ActiveRecord::Migration
  def self.up
    Code.delete_all

    Code.create! :code => "N", :label => "No", :context => "yes_no"
    Code.create! :code => "Y", :label => "Yes", :context => "yes_no"

    Code.create! :code => "P", :label => "Partially", :context => "yes_no.lost"
    Code.create! :code => "U", :label => "Uncertain", :context => "yes_no.lost"

    Code.create! :code => "N", :label => "No", :context => "done", :style => "color: red"
    Code.create! :code => "Y", :label => "Yes", :context => "done", :style => "color: green"
    Code.create! :code => "P", :label => "Progress", :context => "done.work"
    
    # states:
    Code.create! :code => "default", :label => "Default", :context => "state"
    Code.create! :code => "drop", :label => "Dropped", :context => "state"
    Code.create! :code => "future", :label => "Future", :context => "state.work"
    Code.create! :code => "harmony", :label => "Harmony", :context => "state.work"

  end

  def self.down
  end
end
