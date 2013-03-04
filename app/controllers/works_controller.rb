class WorksController < ApplicationController

  def direct_show
    redirect_to(:action => "show", :id => params[:work][:id])
  end

  def show
    redirect_to params.merge(:controller => 'admin/works') if admin?
    @work = Work.find(params[:id])
    redirect_to(:controller => "/") unless @work.state == "default"
      
    @versions = []
    diff = @work.compare_with_version(@work.version)
    @work.versions.reverse.each do |version|
      diff = @work.compare_with_previous version.version
      if (version.version.odd? && !diff.empty?)
        addition = Addition.find version.addition_id if version.addition_id
        comment = VersionComment.find version.version_comment_id if version.version_comment_id 
        @versions.push(
          {:diff => diff,
           :updated_at => version.updated_at,
           :addition => addition,
           :comment => comment,
           :version => version.version})
      end
    end
    @title = "'" + @work.title + "' by " + @work.composer.name
  end

  def compare_version
    @work = Work.find( params[:id] )
    @version = @work.versions[params[:version_id].to_i - 1]
    render :action => 'show'
  end 
  
  def add_comment
  	redirect_to :controller => 'users', :action => 'login', :return_to => "/works/add_comment/#{params[:id]}" unless logged_in?
    if params[:commit] == 'Cancel'
      redirect_to :action => 'show', :id => params[:id], :search_id => params[:search_id] 
      return
    end
    @errors = {}
    @work = Work.find(params[:id])
    @text = params[:text]
    return unless request.post?
    c = Addition.new
    c.text = @text
    c.user_id = current_user.id
    c.work = @work
    if c.save
      mail = Mailer.create_comment_added c
      mail.set_content_type "text/html; charset=utf-8"
      Mailer.deliver mail
      redirect_to :action => 'show', :id => @work, :search_id => params[:search_id] 
      # render :text => "<pre>" + mail.encoded + "</pre>"
    else
      @errors[:text] = c.errors.on :text
    end
  end

end
