stage = "staging"
server "159.203.55.97", port: 22, roles: %w{app web}, primary: true

set :stage,           stage
set :puma_env,        stage
