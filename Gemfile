source "https://rubygems.org"

# Declare your gem's dependencies in basechurch.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

gem 'active_model_serializers'
gem 'acts-as-taggable-on', '~> 3.4'
gem 'acts_as_list'
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'coveralls', require: false
gem 'devise'
gem 'friendly_id', '~> 5.0.0'
gem 'jbuilder'
gem 'rails', '~> 4.1.8'
gem 'rails-api'
gem 'responders'
gem 'travis'

group :development do
  gem 'spring'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'timecop'
end

group :development, :test do
  gem 'guard-rspec'
  gem 'pry'
  gem 'pry-remote'
  gem 'sqlite3'
end

group :staging do
  gem 'pg'
end
