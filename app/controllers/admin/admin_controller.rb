class Admin::AdminController < ApplicationController
  before_filter :login_required
end
  