class Admin::ReferencesController < Admin::AdminController
  before_filter :find_model


  def new
    @quotation = Quotation.new
  end

  def create
    @quotation = Quotation.new(params[:quotation])
    if @quotation.save
      redirect_to :action => 'show', :id => @quotation
    else
      render :action => 'new'
    end
  end

  def update
    if params[:cancel]
      redirect_to :action => 'show', :id => @quotation, :search_id => params[:search_id]
      return
    end
  
    if @quotation.update_attributes(params[:quotation])
      redirect_to :action => 'show', :id => @quotation, :search_id => params[:search_id]
    else
      render :action => 'edit'
    end
  end

  

  private
  def find_model
    @quotation = Quotation.find(params[:id]) if params[:id]
    @title = @quotation.label if @quotation
  end
end