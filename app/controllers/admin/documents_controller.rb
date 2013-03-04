class Admin::DocumentsController < Admin::AdminController

  habtm_actions :works,       :partial_location => :bottom, 
                              :class_name => 'DocumentUsage'
  habtm_actions :composers,   :partial_location => :bottom, 
                              :class_name => 'DocumentUsage'
  habtm_actions :publishers,  :partial_location => :bottom, 
                              :class_name => 'DocumentUsage'
  habtm_actions :libraries,   :partial_location => :bottom, 
                              :class_name => 'DocumentUsage'

  def new
    @document = Document.new
    session[:works] = []
    session[:composers] = []
    session[:libraries] = []
    session[:publishers] = []
  end

  def show
    logger.debug "Invoked method DocumentsController.show"
    @document = Document.find params[:id]
  end

  def edit
    logger.debug "Invoked method DocumentsController.edit"
    @document = Document.find params[:id]
    session[:works] = @document.document_usages.find(:all, :conditions => "usage_type = 'Work'").dup
    session[:composers] = @document.document_usages.find(:all, :conditions => "usage_type = 'Composer'").dup
    session[:libraries] = @document.document_usages.find(:all, :conditions => "usage_type = 'Library'").dup
    session[:publishers] = @document.document_usages.find(:all, :conditions => "usage_type = 'Publisher'").dup
  end
  
  def create
    logger.debug "Invoked method DocumentsController.create"

    if params[:create] == "Create"
      @document = Document.create(params[:document])
      # save all usages:
      all_usages =  session[:works] | session[:composers] | 
                    session[:libraries] | session[:publishers]
      all_usages.each do |usage|
        logger.debug "Saving document usage: #{usage.inspect}."
        usage.save
      end
      @document.document_usages = all_usages
      @document.save
      # clear session objects
      session[:works] = session[:composers] = session[:libraries] = session[:publishers] = nil
      redirect_to :action => 'show', :id => @document
    else
      # clear session objects
      session[:works] = session[:composers] = session[:libraries] = session[:publishers] = nil
      redirect_to :controller => "/", :action => 'index'
    end
  end

  
  def update
    logger.debug "Invoked method DocumentsController.update"
    @document = Document.find params[:id]

    if params[:save] == "Save"
      # save all usages:
      all_usages =  session[:works] | session[:composers] | 
                    session[:libraries] | session[:publishers]
      all_usages.each do |usage|
        logger.debug "Saving document usage: #{usage.inspect}."
        usage.save
      end
      @document.document_usages = all_usages
      @document.update_attributes params[:document]
    end
    
    # clear session objects
    session[:works] = session[:composers] = session[:libraries] = session[:publishers] = nil

    redirect_to :action => 'show', :id => @document
  end
  
  
end