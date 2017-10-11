# create shared directory structure for app
app_name = "#{node['app']}_#{node['stage']}"
path = "/home/#{node['user']['name']}/apps/#{app_name}/shared/config"
execute "mkdir -p #{path}" do
  user node['user']['name']
  group node['group']
  creates path
end

# create database.yml file
template "#{path}/database.yml" do
  source "database.yml.erb"
  mode 0640
  owner node['user']['name']
  group node['group']
end

# set unicorn config
template "/etc/init.d/unicorn_#{app_name}" do
  source "unicorn.sh.erb"
  mode 0755
  owner node['user']['name']
  group node['group']
end

template "#{path}/unicorn.rb" do
  source "unicorn.rb.erb"
  mode 0755
  owner node['user']['name']
  group node['group']
end

# add init script link
execute "update-rc.d unicorn_#{app_name} defaults" do
  not_if "ls /etc/rc2.d | grep unicorn_#{app_name}"
end
