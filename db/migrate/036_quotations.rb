class Quotations < ActiveRecord::Migration
  def self.up
    rename_table "references", "quotations"
    create_table :quotations_works, :force => true do |t|
      t.integer  :work_id
      t.integer  :quotation_id
      t.string   :comment
      t.datetime :created_at
      t.datetime :updated_at
    end
    Work.find(:all).each do |work|
      if work.reference
        work.reference.split(";").each do |reference|
          label, comment = reference.strip.split(":")
          r = Quotation.find_by_label(label)
          if r
            QuotationsWork.create! :quotation_id => r.id, :work_id => work.id, :comment => comment
          else
            say "Reference #{reference} für Werk #{work.id} konnte nicht aufgelöst werden. Bitte manuell korrigieren."
          end
        end
      end
    end
  end

  def self.down
    drop_table :quotations_works
    rename_table "quotations", "references"
  end
end
