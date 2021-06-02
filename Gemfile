source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'
# Use pg as the database for Active Record
gem 'pg', '~> 1.2'
# Use Puma as the app server
gem 'unicorn', group: :production
gem 'thin', group: :development
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 1.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby, group: :test
# stick with sprockets 3 for now
gem 'sprockets', '~> 3.7'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

gem 'activeresource'

gem 'dragonfly', '~> 1.4'
gem 'state_machines-activerecord', '~> 0.5'

gem 'egov_utils', '~> 0.4'
gem 'paranoia', '~> 2.4'
gem 'acts_as_list', '~> 0.9'

gem 'phonelib', '~> 0.6'

gem 'sidekiq', '~> 5.0'

# Use Capistrano for deployment
group :development do
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-sidekiq', require: false
end

gem 'database_cleaner', group: :test
gem 'database_cleaner', group: :staging, require: false

gem 'factory_bot_rails', '~> 4.0', group: [:development, :test]
gem 'factory_bot_rails', '~> 4.0', group: [:staging], require: false

group :development, :test do
  gem 'rspec-rails'

  gem 'pry-rails'
end

group :test do
  gem 'webmock'
  gem 'simplecov', '~> 0.17.1', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'i18n-debug'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
