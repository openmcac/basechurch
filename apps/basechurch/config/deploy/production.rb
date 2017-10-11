stage = "production"
server '45.55.126.192', port: 22, roles: %w{app web}, primary: true

set :stage,           stage
set :puma_env,        stage
