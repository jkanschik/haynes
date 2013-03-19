class CommentCharacters < ActiveRecord::Migration
  def self.up
    [ Abbreviation, Addition, Alia, Blog, Code, Composer, ComposersWorkVersion, ComposersWork, Country,
      Decade, DocumentUsage, Document, Generation, 
      Instrumentation, InstrumentationsWork, InstrumentationsWorkVersion, 
      LibrariesWorkVersion, LibrariesWork, Library, 
      Problem, Publisher, PublishersWorkVersion, PublishersWork, 
      Quotation, QuotationsWork, Source, User, VersionComment, 
      WorkRelation, WorkVersion, Work
    ].each do |klazz|
      klazz.send :reset_column_information
      klazz.send(:columns).each do |column|
        if column.text?
          execute "alter table #{klazz.table_name} modify #{column.name} #{column.sql_type} character set utf8"
        end
      end
    end
  end

  def self.down
  end
end
