source "https://rubygems.org"

# Declare your gem's dependencies in basechurch.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

group :development do
  gem "capistrano"
  gem "capistrano-bundler"
  gem "capistrano-rails"
  gem "capistrano3-puma"
  gem "knife-solo", "~> 0.4.2"
  gem "rubocop", require: false
  gem "spring"
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "factory_girl_rails"
  gem "rspec-its"
  gem "rspec-rails"
  gem "timecop"
end

group :development, :test do
  gem "coveralls"
  gem "guard-rspec"
  gem "marco-polo"
  gem "pry-nav"
  gem "pry-rails"
  gem "pry-remote"
  gem "sqlite3"
  gem "travis", "~> 1.5.0"
  gem "rspec_api_documentation"
end

group :development, :test, :staging do
  gem "forgery"
end

group :staging, :production do
  gem "pg"
  gem "prerender_rails"
end

group :assets do
  gem "uglifier"
end

gem "acts-as-taggable-on", "~> 3.5.0"
gem "acts_as_list", "~> 0"
gem "bcrypt-ruby", "~> 3.1.2"
gem "devise", "~> 3.5.6"
gem "devise_token_auth", "~> 0.1.36"
gem "friendly_id", "~> 5.0.0"
gem "jbuilder", "~> 2.2.6"
gem "jsonapi-resources", "~> 0.9.0"
gem "omniauth-facebook"
gem "puma"
gem "rack-cors", require: "rack/cors"
gem "rack-rewrite", "~> 1.5.0"
gem "rails", "~> 4.2.4"
gem "rails-api", "~> 0.3.1"
gem "settingslogic"
gem "sidekiq"
gem "validate_url", "~> 1.0.0"
