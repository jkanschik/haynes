class SessionsController < ApplicationController

  def new
    @session = Session.new params[:session]
  end

  def create
    @session = Session.new params[:session]
    
    (render(action: 'new') && return) if @session.invalid?

    user = User.authenticate(@session.logname, @session.password)
    if user
      if @session.remember_me
        logger.debug "User selected 'remember_me' for login."
        user.remember_me
        cookies[:auth_token] = { :value => user.remember_token , :expires => user.remember_token_expires_at }
      end
      session[:user] = user.id
      logger.info "Login has been successful for user '#{@session.logname}'."
      redirect_back_or_default('/')
    else
      flash[:notice] = "Authentication failed, please check user name and password."
      render action: 'new'
    end
  end

  def destroy
    current_user.forget_me if current_user
    cookies[:auth_token] = nil
    session[:return_to] = request.env["HTTP_REFERER"]
    session[:user] = nil
    redirect_back_or_default(:controller => '/')
  end

end

class Session
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :logname, :password, :remember_me

  validates :logname, presence: {message: "Please provide your user name."}
  validates :password, presence: {message: "Please input your password."}

  def initialize(attributes = {})
    (attributes || {}).each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
