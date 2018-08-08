# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile << %r(bootstrap-sass/assets/fonts/bootstrap/[\w-]+\.(?:eot|svg|ttf|woff2?)$)
Rails.application.config.assets.precompile += %w(
	jquery3

	jquery-ui/version
	jquery-ui/keycode
	jquery-ui/widgets/datepicker
	jquery-ui/widget
	jquery-ui/widgets/controlgroup
	jquery-ui/widgets/checkboxradio
	jquery-ui/widgets/button
	jquery-ui/ie
	jquery-ui/widgets/mouse
	jquery-ui/widgets/data
	jquery-ui/widgets/plugin
	jquery-ui/widgets/safe-active-element
	jquery-ui/widgets/safe-blur
	jquery-ui/widgets/scroll-parent
	jquery-ui/widgets/draggable
	jquery-ui/disable-selection
	jquery-ui/widgets/resizable
	jquery-ui/focusable
	jquery-ui/widgets/position
	jquery-ui/tabbable
	jquery-ui/unique-id
	jquery-ui/widgets/dialog
	jquery-ui/widgets/sortable
	jquery-ui/escape-selector
	jquery-ui/widgets/tabs

    jquery_ujs

    active_admin/base

    active_admin/lib/batch_actions
    active_admin/lib/checkbox-toggler
    active_admin/lib/dropdown-menu
    active_admin/lib/flash
    active_admin/lib/has_many
    active_admin/lib/modal_dialog
    active_admin/lib/per_page
    active_admin/lib/table-checkbox-toggler

	active_admin/ext/jquery
	active_admin/ext/jquery-ui

	active_admin/initializers/batch_actions
	active_admin/initializers/datepicker
	active_admin/initializers/filters
	active_admin/initializers/tabs

	jquery.ui.datepicker-zh-CN.js 
	admin/user_companies 
)