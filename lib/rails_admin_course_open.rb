require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdminCourseOpen
end
 
module RailsAdmin
  module Config
    module Actions
      class CourseOpen < RailsAdmin::Config::Actions::Base
        # There are several options that you can set here. 
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.
 
        register_instance_option :bulkable? do
          true
        end
 
        register_instance_option :controller do
          Proc.new do
            # Get all selected rows
            @objects = list_entries(@model_config, :destroy)
 
            # Update field open to true
            @objects.each do |object|
                object.update_attribute(:open, true)
            end
 
            flash[:success] = "#{@model_config.label} successfully opend."
 
            redirect_to back_or_index
          end
        end
      end

      class CourseClose < RailsAdmin::Config::Actions::Base
        # There are several options that you can set here. 
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.
 
        register_instance_option :bulkable? do
          true
        end
 
        register_instance_option :controller do
          Proc.new do
            # Get all selected rows
            @objects = list_entries(@model_config, :destroy)
            # Update field open to true
            @objects.each do |object|
                object.update_attribute(:open, false)
            end
 
            flash[:success] = "#{@model_config.label} successfully closed."
 
            redirect_to back_or_index
          end
        end
      end


    end
  end
end