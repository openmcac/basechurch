# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mcac'
set :repo_url, 'git@github.com:openmcac/basechurch'

# Default branch is :master
# Uncomment the following line to have Capistrano ask which branch to deploy.
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Replace the sample value with the name of your application here:
set :deploy_to, '/u/apps/mcac_production'

# Use agent forwarding for SSH so you can deploy with the SSH key on your workstation.
set :ssh_options, {
  forward_agent: true
}

# Default value for :pty is false
set :pty, true

set :linked_files, %w{config/database.yml config/secrets.yml .rbenv-vars .ruby-version config/unicorn.rb}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: "/opt/rbenv/shims:$PATH" }

set :keep_releases, 5

set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
set :bundle_bins, fetch(:bundle_bins, []).push("unicorn")

namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end

  after 'deploy:publishing', 'restart'
end
