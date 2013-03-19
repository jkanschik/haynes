class ConvertDecadeGeneration < ActiveRecord::Migration
  def self.up
    add_column :works, :year, :integer
    add_column :works, :first_year, :integer
    add_column :works, :last_year, :integer
    # initialise first/last year based on decade/generation:
    Work.reset_column_information
    works = Work.find(:all)
    works.each do |work|
      Work.without_locking do
        Work.without_revision do
          if work.decade
            say "Work #{work.id} - Decade ist bekannt: #{work.decade.label}."
            work.first_year = work.decade.first_year
            work.last_year = work.decade.last_year
          elsif work.generation
            say "Work #{work.id} - Generation ist bekannt: #{work.generation.label}."
            work.first_year = work.generation.first_year
            work.last_year = work.generation.last_year
          end
          work.save
        end
      end
    end
  end

  def self.down
    remove_column :works, :year
    remove_column :works, :first_year
    remove_column :works, :last_year
  end
end
