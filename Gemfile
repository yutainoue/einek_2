source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_decorator'
gem 'active_hash'
gem 'activerecord-import'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'
gem 'bootstrap-sass'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'
gem 'capybara'
gem 'chosen-rails'
gem 'coffee-rails', '~> 4.2'
gem 'compass-rails', '~> 2.0.alpha.0'
gem 'erb2haml'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'mechanize'
gem 'momentjs-rails', '>= 2.9.0'
gem 'mysql2', '~> 0.3.20'
gem 'poltergeist'
gem 'puma', '~> 3.7'
gem 'rails', '5.1.4'
gem 'ransack'
gem 'rubyzip', '>= 1.2.1'
gem 'sanitize'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'loofah', '~> 2.2.1'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'redis-namespace'
gem 'sidekiq-scheduler'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'seed-fu'
  gem 'spring-commands-rspec'
  gem 'xray-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
