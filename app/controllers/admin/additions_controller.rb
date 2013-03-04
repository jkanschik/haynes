class Admin::AdditionsController < ApplicationController

  # GET /additions/1
  # GET /additions/1.xml
  def show
    @additions = Addition.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @additions }
    end
  end


  # PUT /additions/1
  # PUT /additions/1.xml
#  def update
#    @addition = Addition.find(params[:id])

#    respond_to do |format|
#      if @addition.update_attributes(params[:addition])
#        format.xml  { head :ok }
#      else
#        format.xml  { render :xml => @addition.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /additions/1
  # DELETE /additions/1.xml
#  def destroy
#    @additions = Addition.find(params[:id])
#    @additions.destroy

#    respond_to do |format|
#      format.xml  { head :ok }
#    end
#  end


  def since_created
    render :xml => Addition.find(:all, :conditions => ["created_at > ? and state <> 'deleted' ", params[:created_at]])
  end

end
