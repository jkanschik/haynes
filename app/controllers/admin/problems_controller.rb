class Admin::ProblemsController < Admin::AdminController

  def show
    @problem = Problem.find(params[:id])
  end

  def new
    @problem = Problem.new
  end

  def create
    @problem = Problem.new(params[:problem])
    if @problem.save
      redirect_to :action => 'show', :id => @problem
    else
      render :action => 'new'
    end
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def update
    @problem = Problem.find(params[:id])
    if params[:cancel]
      redirect_to :action => 'show', :id => @problem, :search_id => params[:search_id]
      return
    end
  
    if @problem.update_attributes(params[:publisher])
      redirect_to :action => 'show', :id => @problem, :search_id => params[:search_id]
    else
      render :action => 'edit'
    end
  end

end
