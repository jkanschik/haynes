class CreateCodeTable < ActiveRecord::Migration
  def self.up
    create_table :codes, :force => true do |t|
      t.string :code,     :null => false
      t.string :label,    :null => false
      t.string :context
      t.string :style
      t.timestamps
    end
    # codes Y and N apply to (almost) all cases
    Code.create! :code => "N", :label => "No"
    Code.create! :code => "Y", :label => "Yes"
    
    # special codes for special contexts, please note P for Progress and Partially, depending on the context
    Code.create! :code => "N", :label => "No", :context => "works.done", :style => "color: red"
    Code.create! :code => "Y", :label => "Yes", :context => "works.done", :style => "color: green"
    Code.create! :code => "P", :label => "Progress", :context => "works.done"
    
    Code.create! :code => "P", :label => "Partially", :context => "works.lost"
    Code.create! :code => "U", :label => "Uncertain", :context => "works.lost"

    Code.create! :code => "N", :label => "No", :context => "publishers.done", :style => "color: red"
    Code.create! :code => "Y", :label => "Yes", :context => "publishers.done", :style => "color: green"

    Code.create! :code => "N", :label => "No", :context => "libraries.done", :style => "color: red"
    Code.create! :code => "Y", :label => "Yes", :context => "libraries.done", :style => "color: green"

    # states:
    Code.create! :code => "default", :label => "Default"
    Code.create! :code => "drop", :label => "Dropped"
    Code.create! :code => "future", :label => "Future", :context => "works.state"
    Code.create! :code => "harmony", :label => "Harmony", :context => "works.state"
    
  end

  def self.down
    drop_table :codes
  end
end
