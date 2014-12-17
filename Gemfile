source 'https://rubygems.org'

gem 'devise'

gem 'rails', '4.1.7'

gem 'rails-api'

gem 'acts-as-taggable-on', '~> 3.4'
gem 'active_model_serializers'

gem 'spring', :group => :development

gem 'friendly_id', '~> 5.0.0'

gem 'travis'

gem 'coveralls', require: false

group :development, :test do
  gem 'guard-rspec'
  gem 'pry'
  gem 'pry-remote'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'sqlite3'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'factory_girl_rails'
  gem 'rspec-its'
  gem 'forgery'
  gem 'timecop'
end

group :staging do
  gem 'pg'
end

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
