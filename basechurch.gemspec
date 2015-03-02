$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "basechurch/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "basechurch"
  s.version     = Basechurch::VERSION
  s.authors     = ["Montreal Chinese Alliance Church"]
  s.email       = ["dev@mcac.church"]
  s.homepage    = "http://mcac.church"
  s.summary     = "An API for your church."
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "acts-as-taggable-on", "~> 3.4", ">= 3.4.2"
  s.add_dependency "acts_as_list", "~> 0"
  s.add_dependency "bcrypt-ruby", "~> 3.1", ">= 3.1.2"
  s.add_dependency "devise", "~> 3.4", ">= 3.4.1"
  s.add_dependency "friendly_id", "~> 5.0", ">= 5.0.0"
  s.add_dependency "jbuilder", "~> 2.2", ">= 2.2.6"
  s.add_dependency "jsonapi-resources", "~> 0.1.0", ">= 0.1.0"
  s.add_dependency "rails", "~> 4.1.8", ">= 4.1.8"
  s.add_dependency "rails-api", "~> 0.3", ">= 0.3.1"
  s.add_dependency "travis", "~> 1.5", ">= 1.5.0"
end
