class Admin::LibrariesController < Admin::AdminController

  def show
    @library = Library.find(params[:id])
    @title = @library.label
  end

  def new
    @library = Library.new
  end

  def create
    @library = Library.new(params[:library])
    if @library.save
      redirect_to :action => 'show', :id => @library
    else
      render :action => 'new'
    end
  end

  def edit
    @library = Library.find(params[:id])
  end

  def update
    @library = Library.find(params[:id])
    if params[:cancel]
      redirect_to :action => 'show', :id => @library, :search_id => params[:search_id]
      return
    end
  
    if @library.update_attributes(params[:library])
      redirect_to :action => 'show', :id => @library, :search_id => params[:search_id]
    else
      render :action => 'edit'
    end
  end

end
