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

group :development do
  gem 'spring'
  gem 'rubocop', require: false
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
  gem 'coveralls'
  gem 'guard-rspec'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-remote'
  gem 'marco-polo'
  gem 'sqlite3'
end

group :staging do
  gem 'pg'
end
