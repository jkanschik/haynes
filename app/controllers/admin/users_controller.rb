class Admin::UsersController < ApplicationController

  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @user }
    end
  end


  # PUT /users/1.xml
#  def update
#    @user = User.find(params[:id])
#
#   respond_to do |format|
#      if @user.update_attributes(params[:user])
#        format.xml  { head :ok }
#      else
#        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /additions/1.xml
#  def destroy
#    @user = User.find(params[:id])
#    @user.destroy

#    respond_to do |format|
#      format.xml  { head :ok }
#    end
#  end


  def since_created
    render :xml => User.find(:all, :conditions => ["created_at > ? and state <> 'deleted' ", params[:created_at]])
  end

end
