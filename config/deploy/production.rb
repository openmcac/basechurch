server "159.203.115.125", user: "deploy", roles: %w{web app db}
set :deploy_to, '/u/apps/mcac_production'
set :unicorn_config_path, "/u/apps/mcac_production/current/config/unicorn.rb"

