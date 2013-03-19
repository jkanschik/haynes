class AddInstruments < ActiveRecord::Migration
  def self.up
    
    create_table :instruments, :force => true do |t|
      t.column :id,         :integer
      t.column :label,      :string
      t.column :order,      :integer
      t.column :name,       :string
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime, :null => false
    end

    Instrument.create!({:label => "A", :order => 30, :name => "Alto"})
    Instrument.create!({:label => "B", :order => 60, :name => "Bass (voice)"})
    Instrument.create!({:label => "Bc", :order => 900, :name => "Basso continuo"})
    Instrument.create!({:label => "Bcl", :order => 228, :name => "Bass clarinet"})
    Instrument.create!({:label => "Bhn", :order => 225, :name => "Basset horn"})
    Instrument.create!({:label => "Bsn", :order => 230, :name => "Bassoon"})
    Instrument.create!({:label => "Btn", :order => 50, :name => "Baritone"})
    Instrument.create!({:label => "Cb", :order => 440, :name => "Contrabass"})
    Instrument.create!({:label => "Ch", :order => 222, :name => "Chalumeau"})
    Instrument.create!({:label => "Cl", :order => 220, :name => "Clarinette"})
    Instrument.create!({:label => "Co", :order => 312, :name => "Cornetto"})
    Instrument.create!({:label => "CT", :order => 35, :name => "Counter Tenor"})
    Instrument.create!({:label => "Dv", :order => 414, :name => "Dessus de viole"})
    Instrument.create!({:label => "EH", :order => 217, :name => "English horn"})
    Instrument.create!({:label => "Fl", :order => 200, :name => "Flute"})
    Instrument.create!({:label => "Gba", :order => 420, :name => "Viola da gamba"})
    Instrument.create!({:label => "Gtr", :order => 480, :name => "Guitar"})
    Instrument.create!({:label => "Har", :order => 490, :name => "Harp"})
    Instrument.create!({:label => "Hps", :order => 600, :name => "Harpsichord"})
    Instrument.create!({:label => "Hrn", :order => 300, :name => "Horn"})
    Instrument.create!({:label => "Lu", :order => 620, :name => "Lute"})
    Instrument.create!({:label => "Mus", :order => 180, :name => "Musette"})
    Instrument.create!({:label => "Orch", :order => 800, :name => "Orchestra"})
    Instrument.create!({:label => "Ob", :order => 210, :name => "Oboe"})
    Instrument.create!({:label => "Obdc", :order => 218, :name => "Oboe da caccia"})
    Instrument.create!({:label => "Obdm", :order => 212, :name => "Oboe d'amore"})
    Instrument.create!({:label => "Org", :order => 610, :name => "Organ"})
    Instrument.create!({:label => "Pf", :order => 605, :name => "Piano"})
    Instrument.create!({:label => "Pic", :order => 209, :name => "Piccolo"})
    Instrument.create!({:label => "Rec", :order => 204, :name => "Recorder"})
    Instrument.create!({:label => "S", :order => 20, :name => "Soprano"})
    Instrument.create!({:label => "Spt", :order => 340, :name => "Serpent"})
    Instrument.create!({:label => "T", :order => 40, :name => "Tenor"})
    Instrument.create!({:label => "Tbn", :order => 320, :name => "Trombone"})
    Instrument.create!({:label => "Tim", :order => 380, :name => "Timpani"})
    Instrument.create!({:label => "Trbl", :order => 100, :name => "Treble instrument"})
    Instrument.create!({:label => "Trp", :order => 310, :name => "Trumpet"})
    Instrument.create!({:label => "Trv", :order => 206, :name => "Traverso"})
    Instrument.create!({:label => "V", :order => 10, :name => "Voice"})
    Instrument.create!({:label => "Va", :order => 410, :name => "Viola"})
    Instrument.create!({:label => "Vadm", :order => 412, :name => "Viola d'amore"})
    Instrument.create!({:label => "Vc", :order => 430, :name => "Violoncello"})
    Instrument.create!({:label => "VF", :order => 208, :name => "voice-flute"})
    Instrument.create!({:label => "Vn", :order => 400, :name => "Violin"})
    Instrument.create!({:label => "Von", :order => 445, :name => "Violone"})
    Instrument.create!({:label => "B", :order => 910, :name => "Bass (not figured)"})
    Instrument.create!({:label => "Tal", :order => 217, :name => "Taille"})
    Instrument.create!({:label => "Obgr", :order => 214, :name => "Oboe grande"})
    Instrument.create!({:label => "Obinf", :order => 216, :name => "Oboe in F"})
    Instrument.create!({:label => "Chr", :order => 90, :name => "Choir"})
    Instrument.create!({:label => "Hco", :order => 120, :name => "Hautecontre"})
    Instrument.create!({:label => "Des", :order => 110, :name => "Dessus"})
    Instrument.create!({:label => "Vie", :order => 105, :name => "Vie ??"})
    
  end  

  def self.down
    drop_table :instruments
  end
end
