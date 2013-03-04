class InstrumentationsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @instrumentation_pages, @instrumentations = paginate :instrumentations, :per_page => 10
  end

  def show
    @instrumentation = Instrumentation.find(params[:id])
  end

  def new
    @instrumentation = Instrumentation.new
  end

  def create
    @instrumentation = Instrumentation.new(params[:instrumentation])
    if @instrumentation.save
      flash[:notice] = 'Instrumentation was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @instrumentation = Instrumentation.find(params[:id])
  end

  def update
    @instrumentation = Instrumentation.find(params[:id])
    if @instrumentation.update_attributes(params[:instrumentation])
      flash[:notice] = 'Instrumentation was successfully updated.'
      redirect_to :action => 'show', :id => @instrumentation
    else
      render :action => 'edit'
    end
  end

  def destroy
    Instrumentation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
