class InfoController < ApplicationController

  
  def statistics
    @pieces = Work.sum(:number)
    @works = Work.count
    @versions = (WorkVersion.count - Work.count) / 2
    @editions = PublishersWork.count - 2202
    @original_works = 0
    @original_pieces = 0
    @lost_yes = 0
    @lost_no = 0
    @lost_part = 0
    @done_yes = 0
    @done_no = 0
    @done_pro = 0
    Work.find(:all).each do |w|
      @done_yes = @done_yes + 1 if w.done == "Y"
      @done_no = @done_no + 1 if w.done == "N"
      @done_pro = @done_pro + 1 if w.done == "P"
      if w.source_id > 1 
        @original_works = @original_works + 1 
        @original_pieces = @original_pieces + w.number
      end
      @lost_yes = @lost_yes + 1 if w.lost == "Y"
      @lost_no = @lost_no + 1 if w.lost == "N"
      @lost_part = @lost_part + 1 if w.lost == "P"
    end
    @library_done_yes = 0
    @library_done_no = 0
    Library.find(:all).each do |l|
      @library_done_yes = @library_done_yes + 1 if l.done == "Y"
      @library_done_no = @library_done_no + 1 if l.done == "N"
    end
    @publisher_done_yes = 0
    @publisher_done_no = 0
   Publisher.find(:all).each do |l|
      @publisher_done_yes = @publisher_done_yes + 1 if l.done == "Y"
      @publisher_done_no = @publisher_done_no + 1 if l.done == "N"
    end
    @composers = Composer.count
    @new_composers = @composers
    Composer.find(:all).each do |c|
      # Wenn es von dem Composer >= 1 Werk mit Source=1 gibt 
      # @new_composers = @new_composers-1
    end
  end

end
