source 'https://rubygems.org'

gem 'rails'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.5'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'haml-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

group :development do
  gem 'hpricot'
  gem 'ruby_parser'
end

gem 'jquery-rails'

group :test, :development do
  gem 'rspec-rails', '2.10.0'
  gem 'guard-rspec', '0.5.5'
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl_rails', '1.4.0'
  gem 'cucumber-rails', '1.2.1', require: false
  gem 'database_cleaner'
  gem 'timecop' #for manipulating time when testing
  gem 'rb-fsevent', require: false
  gem 'growl'
end

group :development, :test, :production do
  gem 'pg', '0.12.2'
end