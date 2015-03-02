require 'jsonapi/resource'
require 'jsonapi/resource_controller'
require 'jsonapi/mime_types'
require 'jsonapi/routing_ext'
require 'acts-as-taggable-on'
require 'acts_as_list'
require 'devise'
require 'friendly_id'
require 'rails-api'

module Basechurch
  class Engine < ::Rails::Engine
    isolate_namespace Basechurch

    config.generators do |g|
      g.test_framework :rspec, view_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end
end
