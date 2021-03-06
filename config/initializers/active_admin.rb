ActiveAdmin.setup do |config|
  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "股票管理系统"
  
  config.comments = false

  # 自定义页脚
    # 自定义页脚
  config.footer = "Copyright © 2018-#{Date.today.year} breo.cn | 任何意见、bug请联系luwulu@foxmail.com"

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  # config.site_title_link = "/"

  # Set an optional image to be displayed for the header
  # instead of a string (overrides :site_title)
  #
  # Note: Aim for an image that's 21px high so it fits in the header.
  #
  # config.site_title_image = "logo.png"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  #
  # Default:
  # config.default_namespace = :admin
  #
  # You can customize the settings for each namespace by using
  # a namespace block. For example, to change the site title
  # within a namespace:
  #
  #   config.namespace :admin do |admin|
  #     admin.site_title = "Custom Admin Title"
  #   end
  #
  # This will ONLY change the title for the admin section. Other
  # namespaces will continue to use the main "site_title" configuration.

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the application controller.
  config.authentication_method = :authenticate_admin_user!

  # == User Authorization
  #
  # Active Admin will automatically call an authorization
  # method in a before filter of all controller actions to
  # ensure that there is a user with proper rights. You can use
  # CanCanAdapter or make your own. Please refer to documentation.
  # config.authorization_adapter = ActiveAdmin::CanCanAdapter

  # In case you prefer Pundit over other solutions you can here pass
  # the name of default policy class. This policy will be used in every
  # case when Pundit is unable to find suitable policy.
  # config.pundit_default_policy = "MyDefaultPunditPolicy"

  # You can customize your CanCan Ability class name here.
  # config.cancan_ability_class = "Ability"

  # You can specify a method to be called on unauthorized access.
  # This is necessary in order to prevent a redirect loop which happens
  # because, by default, user gets redirected to Dashboard. If user
  # doesn't have access to Dashboard, he'll end up in a redirect loop.
  # Method provided here should be defined in application_controller.rb.
  # config.on_unauthorized_access = :access_denied

  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # (within the application controller) to return the currently logged in user.
  config.current_user_method = :current_admin_user

  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  config.logout_link_path = :destroy_admin_user_session_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  # config.logout_link_method = :get

  # == Root
  #
  # Set the action to call for the root path. You can set different
  # roots for each namespace.
  #
  # Default:
  config.root_to = 'stock_statics#index'

  # == Admin Comments
  #
  # This allows your users to comment on any resource registered with Active Admin.
  #
  # You can completely disable comments:
  # config.comments = false
  #
  # You can change the name under which comments are registered:
  # config.comments_registration_name = 'AdminComment'
  #
  # You can change the order for the comments and you can change the column
  # to be used for ordering:
  # config.comments_order = 'created_at ASC'
  #
  # You can disable the menu item for the comments index page:
  # config.comments_menu = false
  #
  # You can customize the comment menu:
  # config.comments_menu = { parent: 'Admin', priority: 1 }

  # == Batch Actions
  #
  # Enable and disable Batch Actions
  #
  config.batch_actions = true

  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources and pages from here.
  #
  # config.before_action :do_something_awesome

  # == Localize Date/Time Format
  #
  # Set the localize format to display dates and times.
  # To understand how to localize your app with I18n, read more at
  # https://github.com/svenfuchs/i18n/blob/master/lib%2Fi18n%2Fbackend%2Fbase.rb#L52
  #
  config.localize_format = :long

  # == Setting a Favicon
  #
  # config.favicon = 'favicon.ico'

  # == Meta Tags
  #
  # Add additional meta tags to the head element of active admin pages.
  #
  # Add tags to all pages logged in users see:
  #   config.meta_tags = { author: 'My Company' }

  # By default, sign up/sign in/recover password pages are excluded
  # from showing up in search engine results by adding a robots meta
  # tag. You can reset the hash of meta tags included in logged out
  # pages:
  #   config.meta_tags_for_logged_out_pages = {}

  # == Removing Breadcrumbs
  #
  # Breadcrumbs are enabled by default. You can customize them for individual
  # resources or you can disable them globally from here.
  #
  # config.breadcrumb = false

  # == Create Another Checkbox
  #
  # Create another checkbox is disabled by default. You can customize it for individual
  # resources or you can enable them globally from here.
  #
  # config.create_another = true

  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'
  #
  # You can provide an options hash for more control, which is passed along to stylesheet_link_tag():
  #   config.register_stylesheet 'my_print_stylesheet.css', media: :print
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'

  # == CSV options
  #
  # Set the CSV builder separator
  # config.csv_options = { col_sep: ';' }
  #
  # Force the use of quotes
  # config.csv_options = { force_quotes: true }

  # == Menu System
  #
  # You can add a navigation menu to be used in your application, or configure a provided menu
  #
  # To change the default utility navigation to show a link to your website & a logout btn
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :utility_navigation do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #       admin.add_logout_button_to_menu menu
  #     end
  #   end
  #
  # If you wanted to add a static menu item to the default menu provided:
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :default do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #     end
  #   end

  # == Download Links
  #
  # You can disable download links on resource listing pages,
  # or customize the formats shown per namespace/globally
  #
  # To disable/customize for the :admin namespace:
  #
  #   config.namespace :admin do |admin|
  #
  #     # Disable the links entirely
  #     admin.download_links = false
  #
  #     # Only show XML & PDF options
  #     admin.download_links = [:xml, :pdf]
  #
  #     # Enable/disable the links based on block
  #     #   (for example, with cancan)
  #     admin.download_links = proc { can?(:view_download_links) }
  #
  #   end

  # == Pagination
  #
  # Pagination is enabled by default for all resources.
  # You can control the default per page count for all resources here.
  #
  config.default_per_page = 10
  #
  # You can control the max per page count too.
  #
  config.max_per_page = 100

  # == Filters
  #
  # By default the index screen includes a "Filters" sidebar on the right
  # hand side with a filter for each attribute of the registered model.
  # You can enable or disable them for all resources here.
  #
  # config.filters = true
  #
  # By default the filters include associations in a select, which means
  # that every record will be loaded for each association.
  # You can enabled or disable the inclusion
  # of those filters by default here.
  #
  # config.include_default_association_filters = true

  # == Footer
  #
  # By default, the footer shows the current Active Admin version. You can
  # override the content of the footer here.
  #
  # config.footer = 'my custom footer text'

  # == Sorting
  #
  # By default ActiveAdmin::OrderClause is used for sorting logic
  # You can inherit it with own class and inject it for all resources
  #
  # config.order_clause = MyOrderClause
end

class ActiveAdmin::ResourceController
  module Streaming
    class DummyController
      def initialize(collection:)
        @collection = collection
      end
      attr_reader :collection

      def find_collection(*)
        collection
      end

      def apply_decorator(resource)
        resource
      end

      def view_context
        @view_context ||= ViewContext.new
      end

      class ViewContext
        include MethodOrProcHelper
      end
    end

    def export_csv(collection)
      controller = DummyController.new(collection: collection)
      headers['Content-Disposition'] = %{attachment; filename="#{csv_filename}"}
      stream_resource &active_admin_config.csv_builder.method(:build).to_proc.curry[controller]
    end
  end
end

module ActiveAdmin
  module Views
    class PaginatedCollection
      def build_pagination_with_formats(options)
        div :id => "index_footer" do
          build_pagination
          div(page_entries_info(options).html_safe, :class => "pagination_information")
          build_download_format_links([:csv]) unless @download_links == false
        end
      end
    end
  end

  class CSVBuilder
    def self.default_for_resource(resource)
      new resource: resource do
        column :id
      end
    end

    def build(controller, csv)
      @collection  = controller.send :find_collection, except: :pagination
      columns      = exec_columns controller.view_context
      options      = ActiveAdmin.application.csv_options.merge self.options
      bom          = options.delete :byte_order_mark
      column_names = options.delete(:column_names) { true }
      csv_options  = options.except :encoding_options, :humanize_name

      csv << bom if bom

      if column_names
        csv << CSV.generate_line(columns.map{ |c| encode c.name, options }, csv_options)
      end

      ActiveRecord::Base.uncached do
        need_static = true
        statics = []
        static_data = { "StockStatic" => { "sum_stock_num" => 0, "sum_stock_percentage" => 0, "sum_stock_sum_price" => 0, 
                                            "sum_stock_capital_sum" => 0, "sum_stock_capital_percentage" => 0, "sum_stock_register_sum_price" => 0 },
                        "StockCompany" => { "sum_stock_capital_sum" => 0, "sum_stock_stockholders_num" => 0, 
                                            "sum_stock_ransom_sum_price" => 0, "sum_stock_holders_buy_sum_price" => 0 }, 
                        "StockAccount" => { "sum_stock_num" => 0, "sum_stock_percentage" => 0, "sum_stock_sum_price" => 0, 
                                            "sum_stock_capital_sum" => 0, "sum_stock_capital_percentage" => 0 },
                        "RansomStock" => { "sum_stock_num" => 0, "sum_stock_percentage" => 0, "sum_stock_sum_price" => 0 },
                        "AccountStatic" => { "sum_stock_num" => 0, "sum_breo_stock_percentage" => 0, "sum_stock_percentage" => 0 }
                      }
        (1..paginated_collection.total_pages).each do |page|
          paginated_collection(page).each do |resource|
            resource = controller.send :apply_decorator, resource
            csv << CSV.generate_line(build_row(resource, columns, options), csv_options)

            resource_name = resource.class.to_s
            case resource_name
            when "StockStatic"
              if resource.stock_type == StockStatic::STOCK_BUY
                static_data[resource_name]["sum_stock_num"] += resource.breo_stock_num.to_i
                static_data[resource_name]["sum_stock_percentage"] += resource.breo_stock_percentage.to_f
                static_data[resource_name]["sum_stock_sum_price"] += resource.stock_sum_price.to_f
                static_data[resource_name]["sum_stock_capital_sum"] += resource.capital_sum.to_f.to_f
                static_data[resource_name]["sum_stock_capital_percentage"] += resource.capital_percentage.to_f
                static_data[resource_name]["sum_stock_register_sum_price"] += resource.register_sum_price.to_f
              else
                static_data[resource_name]["sum_stock_num"] -= resource.breo_stock_num.to_i
                static_data[resource_name]["sum_stock_percentage"] -= resource.breo_stock_percentage.to_f
                static_data[resource_name]["sum_stock_sum_price"] -= resource.stock_sum_price.to_f
                static_data[resource_name]["sum_stock_capital_sum"] -= resource.capital_sum.to_f.to_f
                static_data[resource_name]["sum_stock_capital_percentage"] -= resource.capital_percentage.to_f
                static_data[resource_name]["sum_stock_register_sum_price"] -= resource.register_sum_price.to_f
              end
              statics = ["合计", "", number_to_currency(static_data[resource_name]["sum_stock_num"], unit: '',  precision: 0), static_data[resource_name]["sum_stock_percentage"].round(4).to_s + " %",
                  "", number_to_currency(static_data[resource_name]["sum_stock_sum_price"], unit: '',  precision: 0), number_to_currency(static_data[resource_name]["sum_stock_capital_sum"], unit: '',  precision: 0),
                  static_data[resource_name]["sum_stock_capital_percentage"].round(4).to_s + " %", "", number_to_currency(static_data[resource_name]["sum_stock_register_sum_price"], unit: '',  precision: 0)]
            when "StockCompany"
              static_data[resource_name]["sum_stock_capital_sum"] += resource.capital_sum.to_f
              static_data[resource_name]["sum_stock_stockholders_num"] += resource.stockholders_num.to_i
              static_data[resource_name]["sum_stock_holders_buy_sum_price"] += resource.holders_buy_sum_price.to_f
              static_data[resource_name]["sum_stock_ransom_sum_price"] += resource.ransom_sum_price.to_f.to_f
              statics = ["合计", number_to_currency(static_data[resource_name]["sum_stock_capital_sum"], unit: '',  precision: 0), number_to_currency(static_data[resource_name]["sum_stock_stockholders_num"], unit: '',  precision: 0), 
                  number_to_currency(static_data[resource_name]["sum_stock_holders_buy_sum_price"], unit: '',  precision: 0), number_to_currency(static_data[resource_name]["sum_stock_ransom_sum_price"], unit: '',  precision: 0)]
            when "StockAccount"
              static_data[resource_name]["sum_stock_num"] += resource.breo_stock_num.to_i
              static_data[resource_name]["sum_stock_percentage"] += resource.breo_stock_percentage.to_f
              static_data[resource_name]["sum_stock_sum_price"] += resource.stock_sum_price.to_f
              static_data[resource_name]["sum_stock_capital_sum"] += resource.capital_sum.to_f.to_f
              static_data[resource_name]["sum_stock_capital_percentage"] += resource.capital_percentage.to_f
              statics = ["合计", "", number_to_currency(static_data[resource_name]["sum_stock_num"], unit: '',  precision: 0), static_data[resource_name]["sum_stock_percentage"].round(4).to_s + " %",
                  "", number_to_currency(static_data[resource_name]["sum_stock_sum_price"], unit: '',  precision: 0), number_to_currency(static_data[resource_name]["sum_stock_capital_sum"], unit: '',  precision: 0),
                  static_data[resource_name]["sum_stock_capital_percentage"].round(4).to_s + " %"]
            when "RansomStock"
              static_data[resource_name]["sum_stock_num"] += resource.breo_stock_num.to_i
              static_data[resource_name]["sum_stock_percentage"] += resource.breo_stock_percentage.to_f
              static_data[resource_name]["sum_stock_sum_price"] += resource.stock_sum_price.to_i
              statics = ["合计", "", number_to_currency(static_data[resource_name]["sum_stock_num"], unit: '',  precision: 0), static_data[resource_name]["sum_stock_percentage"].round(4).to_s + " %", 
                  "", "", "", number_to_currency(static_data[resource_name]["sum_stock_sum_price"], unit: '',  precision: 0)]
            when "AccountStatic"
              static_data[resource_name]["sum_stock_num"] += resource.breo_stock_num.to_i
              static_data[resource_name]["sum_breo_stock_percentage"] += resource.current_breo_stock_percentage.to_f
              static_data[resource_name]["sum_stock_percentage"] += resource.current_company_stock_percentage.to_f
              statics = ["合计", "", number_to_currency(static_data[resource_name]["sum_stock_num"], unit: '',  precision: 0), static_data[resource_name]["sum_breo_stock_percentage"].round(4).to_s + " %", 
                  static_data[resource_name]["sum_stock_percentage"].round(4).to_s + " %"]
            else
              need_static = false
            end
          end
        end
        csv << CSV.generate_line(statics) if need_static
      end

      csv
    end
  end
end