source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '5.0.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'json'
# gem 'jbuilder', '~> 2.5'
# Use json for API
gem 'active_model_serializers'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use jquery as the JavaScript library
gem 'jquery-rails', '4.2.2'
gem 'jquery-ui-rails', '6.0.1'
gem 'jquery-turbolinks'
gem 'select2-rails'
# Use ActiveModel has_secure_password
gem 'bcrypt'
# Use table record count
gem 'counter_culture'
# gem 'rack-contrib', require: 'rack/contrib', git: 'https://github.com/pabse/rack-contrib.git', branch: 'rack_ruby_2+'
gem 'rack-attack', '~> 5.0.1'
# Use error page
# gem 'rambulance'
# Use auto link to content
gem 'rinku'
# Use pagination
gem 'kaminari'
# Use searchform
gem 'ransack'
# Use management user
gem 'devise'
# Use management user for API
# gem 'devise_token_auth', :git => 'https://github.com/lynndylanhurley/devise_token_auth.git', :branch => 'master'
# Use management user for oAuth
gem 'omniauth'
# Use management user languages ja
gem 'devise-i18n'
gem 'rails-i18n'
# Use roles
# gem 'cancancan'
# Use file upload
gem 'carrierwave'
# gem 'rmagick', require: 'RMagick'
# Use post tags
gem 'acts-as-taggable-on'
# Use scraping ogp
gem 'metainspector'
# Use cache
gem 'dalli'
# Use API for cross-domain
gem 'rack-cors', :require => 'rack/cors'
# HTTPクライアントのgem ≒ Rackミドルウェア
# gem 'faraday'
# gem 'faraday_middleware'
# Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
gem 'web-console', '>= 3.3.0'
gem 'listen', '>= 3.0.5', '< 3.2'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'spring-commands-rspec'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  # N+1問題のクエリを警告
  gem 'bullet'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
