source 'https://rubygems.org'

gem 'rails'
gem 'haml'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

#gem 'acts_as_versioned', "~> 0.6.0"
gem 'acts_as_versioned', :git => 'https://github.com/jwhitehorn/acts_as_versioned.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
  
  gem 'rb-fsevent', :require => false
  gem 'growl'
end

gem 'coveralls', require: false
