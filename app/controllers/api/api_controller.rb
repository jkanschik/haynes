class Api::ApiController < ApplicationController

  def timestamps
    return unless authorized?
    records = entity_class().find(:all, :select => "id, updated_at", :order => :id)
    records.map! {|r| "{'id': #{r.id}, 'updated_at': '#{r.updated_at.strftime("%Y-%m-%d %H:%M:%S")}'}"}
    render :json => "[" + records.join(", ") + "]"
  end

  def update
    logger.info "Update called for entity #{entity_name()} with id #{params[:id]}"
    return unless authorized?
    
    klazz = entity_class()
    klazz.record_timestamps = false
    entity = klazz.find(params[:id])
    entity.attributes = params[entity_name()]
    without_version { entity.save_with_validation(false) }
    klazz.record_timestamps = true

    render :json => {:result => :ok}
  end

  def create
    logger.info "Create called for entity #{entity_name()} with id #{params[:id]}"
    return unless authorized?
    
    klazz = entity_class()
    klazz.record_timestamps = false
    entity = klazz.new params[entity_name()]
    entity.id = params[entity_name()][:id]
    without_version { entity.save_with_validation(false) }
    klazz.record_timestamps = true

    render :json => {:result => :ok}
  end

  def destroy
    logger.info "Delete called for entity #{entity_name()} with id #{params[:id]}"
    return unless authorized?
    entity_class().delete(params[:id])

    render :json => {:result => :ok}
  end

protected

  def without_version
    yield
  end
  
  def authorized?
    logger.info "Header: #{request.headers.inspect}"
    user_id = request.headers["HTTP_USER"]
    password = request.headers["HTTP_PASSWORD"]
    user = User.find_by_id(user_id)
    if user.nil? || user.password != password
      logger.info "User not authorized!"
      render :json => {:result => :not_authorized}, :status => 403
      return false
    end
    return true
  end
  
  def entity_class
    Kernel.const_get(entity_name)
  end

  def entity_name
    self.class.name.demodulize.chomp("Controller").singularize
  end

end
