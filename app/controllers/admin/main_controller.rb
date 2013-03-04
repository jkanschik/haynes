class Admin::MainController < Admin::AdminController
  
  def update_incipits
    @result = %x[svn update public/incipits/]
  end
  
  def new_additions
    @additions = Addition.find :all, :conditions => "state = 'new'", :order => "created_at desc"
  end

  def processed_additions
    @additions = Addition.find :all, :conditions => "state = 'processed'", :order => "created_at desc"
  end

  def deleted_additions
    @additions = Addition.find :all, :conditions => "state = 'deleted'", :order => "created_at desc"
  end

end
  