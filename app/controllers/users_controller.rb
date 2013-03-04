class UsersController < ApplicationController

  def login
    # TODO : kann wegfallen, falls Registrierung über link anstelle von button.
    if params[:commit] == 'Register'
      redirect_to :action => 'register'
      return
    end
	  
    # if the login action is called by "get",
    # we just show the login page, because we don't have login data anyway
    if !request.post? or not params[:user]
      session[:return_to] = (params[:return_to] or request.env["HTTP_REFERER"])
      logger.debug "Set session[:return_to] to #{session[:return_to]}."
      @user = User.new logname: params[:logname]
      return
    end

    @errors = {}
    # check whether login name has been input
    if params[:user][:logname] == nil or params[:user][:logname] == ""
      @errors[:logname] = ["Please input the user name."]
      logger.info "Login has been required without any login name."
      return
    end

    # check password
    @user = User.authenticate(params[:user][:logname], params[:user][:password])
    if @user
      if params[:remember_me] == "1"
        logger.debug "User selected 'remember_me' for login."
        @user.remember_me
        cookies[:auth_token] = { :value => @user.remember_token , :expires => @user.remember_token_expires_at }
      end
      session[:user] = @user.id
      logger.info "Login has been successful for user '#{params[:user][:logname]}'."
      redirect_back_or_default('/')
    else
      @errors[:authentication] = ["Authentication failed, please check user name and password."]
      logger.info "Login has been rejected for user #{params[:user][:logname]}."
	    @user = User.new logname: params[:user][:logname]
    end
  end


  def logout
    current_user.forget_me if current_user
    cookies[:auth_token] = nil
    session[:return_to] = request.env["HTTP_REFERER"]
    session[:user] = nil
    redirect_back_or_default(:controller => '/')
  end


  def register
    if !request.post?
      @user = User.new
      return
    end
    @user = User.new(params[:user])
  	if @user.save
    	Mailer.user_registered @user
      redirect_to action: 'login', logname: @user.logname
#      render :action => 'login'
    end
  end

end