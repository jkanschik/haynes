class ApplicationController < ActionController::Base
  protect_from_forgery

  # Pick a unique cookie name to distinguish our session data from others'
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :init_searches

    def self.habtm_actions(name, options = {})
      options.merge :partial_location => :before

      short_name = options[:short_name] || name.to_s.singularize
      class_name = options[:class_name] || short_name.camelize
      session_name = options[:session_name] || name.to_s

      methods =  <<-EOMethod
        def #{short_name}_edit
          record_id = params[:#{short_name}_row_id]
          logger.info 'Replacing html fragment for #{class_name} ' + record_id + ' in session.'
          render :update do |page|
            page.replace "#{short_name}_" + record_id, :partial => '#{short_name}_row_edit',
              :locals => {:#{short_name}_row_id => record_id.to_i, :is_new => false}
          end
        end
        def #{short_name}_add
          data_params = params.reject {|k,v| k == "action" or k == "controller"}
          logger.info 'Adding new #{class_name} with attributes ' + data_params.inspect + ' in session.'
          record = #{class_name}.new data_params
          session[:#{session_name}] << record
          render :update do |page|
            page.insert_html :#{options[:partial_location]}, "add_#{short_name}", :partial => '#{short_name}_row_edit',
              :locals => {:#{short_name}_row_id => session[:#{session_name}].size - 1, :is_new => true}
          end 
        end
        def #{short_name}_save
          record_id = params[:#{short_name}_row_id]
          data_key = "#{short_name}_" + record_id
          logger.info 'Updating #{class_name} ' + record_id + ' in session.'
          record = session[:#{session_name}][record_id.to_i]
          record.attributes = params[data_key.to_sym]
          logger.debug "Objects of class #{class_name} in session: " +  session[:#{session_name}].inspect
          render :update do |page|
            page.replace "#{short_name}_" + record_id, :partial => '#{short_name}_row', :locals => {:#{short_name}_row_id => record_id.to_i}
          end
        end
        def #{short_name}_show
          record_id = params[:#{short_name}_row_id]
          logger.info 'Show #{class_name} ' + record_id + ' from session.'
          render :update do |page|
            page.replace "#{short_name}_" + record_id, :partial => '#{short_name}_row', :locals => {:#{short_name}_row_id => record_id.to_i}
          end
        end
        def #{short_name}_destroy
          record_id = params[:#{short_name}_row_id]
          logger.info 'Removing #{class_name} ' + record_id + ' from session.'
          session[:#{session_name}].delete_at record_id.to_i
          render :update do |page|
            0.upto session[:#{session_name}].size - 1 do |i|
              page.replace "#{short_name}_" + i.to_s, :partial => '#{short_name}_row', :locals => {:#{short_name}_row_id => i}
            end
            page.remove "#{short_name}_" + session[:#{session_name}].size.to_s
          end
        end
      EOMethod

      logger.debug "Generated new methods:"
      logger.debug methods

      class_eval methods
    end

  protected

    def log_processing
      logger.info ""
      logger.info("---------- Starting new request ----------")
      logger.info("Starting_time: #{Time.now.utc}")
      logger.info("Request: #{request.request_uri}")
      super
    end

    def init_searches
      session[:searches] = {} unless session[:searches]
      @search = session[:searches][params[:search_id]]
    end
end
