class Admin::ComposersController < Admin::AdminController

  habtm_actions :alias,        :partial_location => :before

  def new
    @composer = Composer.new
    session[:alias] = @composer.alias.dup
  end

  def create
    @composer = Composer.new(params[:composer])
    if @composer.save
      flash[:notice] = 'Composer was successfully created.'
      redirect_to :action => 'show', :id => @composer
    else
      render :action => 'new'
    end
  end

  def edit
    @composer = Composer.find(params[:id])
    session[:alias] = @composer.alias.dup
  end
  
  def show
    @composer = Composer.find(params[:id])
    @title = @composer.full_name
  end

  def update
    @composer = Composer.find(params[:id])
    if params[:cancel]
      redirect_to :action => 'show', :id => @composer, :search_id => params[:search_id]
      return
    end

    logger.debug "Saving alias from session..."
    session[:alias].each do |a|
      logger.debug "Saving alias: #{a.inspect}."
      a.save
    end
    @composer.alias = session[:alias]
    @composer.alias(true)
  
  
    if @composer.update_attributes(params[:composer])
      redirect_to :action => 'show', :id => @composer, :search_id => params[:search_id]
    else
      render :action => 'edit'
    end
  end

end
