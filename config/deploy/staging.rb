server "159.203.38.244", user: "deploy", roles: %w{web app db}
set :deploy_to, '/u/apps/mcac_staging'
set :unicorn_config_path, "/u/apps/mcac_staging/current/config/unicorn.rb"
