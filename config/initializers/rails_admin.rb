require Rails.root.join('lib', 'rails_admin_course_open.rb')

RailsAdmin.config do |config|

  # config.main_app_name = ["Cool app", "BackOffice"]
  # or something more dynamic
  config.main_app_name = Proc.new { |controller| ["CourseSelect", "控制面板"] }

  # config.authorize_with :cancan, AdminAbility

  config.included_models = ['User','Course','Grade']

  # config.model ['Relationship'] do
  #   navigation_label 'Association'
  # end
  # config.navigation_static_links = {
  #     'Google' => 'http://www.google.com'
  # }
  # config.navigation_static_label = "My Links"

  # == Authenticate ==
  config.authorize_with do
    if !current_user.admin
      redirect_to main_app.root_url, flash: {:danger => '请先以管理员身份登陆'}
    end
  end

  config.current_user_method(&:current_user)

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration


  # Register the class in lib/rails_admin_publish.rb
  module RailsAdmin
    module Config
      module Actions
        class CourseOpen < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
        class CourseClose < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
      end
    end
  end


  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    # show_in_app
    course_open do
      # Make it visible only for Course model. You can remove this if you don't need.
      visible do
        bindings[:abstract_model].model.to_s == "Course"
      end
    end
    course_close do
      # Make it visible only for Course model. You can remove this if you don't need.
      visible do
        bindings[:abstract_model].model.to_s == "Course"
      end
    end
  end

end
