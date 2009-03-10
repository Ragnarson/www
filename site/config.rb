require 'compass'   # Compass Stylesheet Framework
require 'ninesixty' # 960 Grid System plugin

Compass.configuration do |config|
  config.project_path = File.dirname(__FILE__)
  config.sass_dir     = File.join('src', 'sass' )
  config.css_dir      = File.join('src', 'stylesheets' )
end
