class Admin::PublishersController < Admin::AdminController
  before_filter :init_model, only: [:show, :edit, :update]

  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(params[:publisher])
    if @publisher.save
      redirect_to admin_publisher_path(@publisher), notice: 'Publisher was successfully created.' 
    else
      render action: 'new'
    end
  end

  def update
    if @publisher.update_attributes(params[:publisher])
      redirect_to admin_publisher_path(@publisher), :search_id => params[:search_id], notice: 'Demo was successfully updated.'
    else
      render :action => 'edit'
    end
  end

private
  def init_model
    @publisher = Publisher.find(params[:id]) if params[:id]
    @title = @publisher.label if @publisher
  end
end
