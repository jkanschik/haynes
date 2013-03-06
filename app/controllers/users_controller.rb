class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      Mailer.user_registered @user
      redirect_to new_session_path(session: {logname: @user.logname})
    else
      render action: 'new'
    end
  end

end
