class FixAnonymous < ActiveRecord::Migration
  # reduziert die Versionsnummer um 1, 
  # löscht die Version mit Nummer 2 und reduziert die Nummer aller weiteren um 1.
  # Version 1 bleibt unverändert.
  def self.reduce_version entity
    entity.version -= 1
    entity.save!

    entity.versions.each do |v|
      say "  Process version #{v.version}."
      if v.version == 2
        v.destroy 
      elsif v.version > 2
        v.version -= 1
        v.save!
      end
    end
  end
  def self.up
    works = Work.find(:all, :conditions => 'composer_id = 19')
    works.each do |work|
      Work.without_locking do
        Work.without_revision do
          say "Reduce version for work id = #{work.id}."
          reduce_version work
          
          work.libraries_works.each do |lw|
            say "Reduce version for libraries_works id = #{lw.id}."
            LibrariesWork.without_locking do
              LibrariesWork.without_revision do
                reduce_version lw if lw.version and lw.version > 1
              end
            end
          end
          work.publishers_works.each do |lw|
            say "Reduce version for publishers_works id = #{lw.id}."
            PublishersWork.without_locking do
              PublishersWork.without_revision do
                reduce_version lw if lw.version and lw.version > 1
              end
            end
          end
          work.instrumentations_works.each do |lw|
            say "Reduce version for instrumentations_works id = #{lw.id}."
            InstrumentationsWork.without_locking do
              InstrumentationsWork.without_revision do
                reduce_version lw if lw.version and lw.version > 1
              end
            end
          end
        end
      end
    end

  end

  def self.down
  end
end
