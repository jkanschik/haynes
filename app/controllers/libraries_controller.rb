class LibrariesController < ApplicationController

  def show
    @library = Library.find(params[:id])
    @library_works = LibrariesWork.count(:joins => :work, :conditions => ["library_id = ? and state = 'default'", params[:id]])
    @successors = Library.count(:conditions => {:successor_id => params[:id]})
    @title = @library.label
  end

end
