directory node['dripstat']['home'] do
  owner node['dripstat']['owner']
  group node['dripstat']['owner']
  mode 00755
  action :create
  recursive true
end

zipname = "dripstat_agent-#{node['dripstat']['agent']['version']}.zip"
dripstat_zip = "#{node['dripstat']['home']}/#{zipname}"

remote_file dripstat_zip do
  source "#{node['dripstat']['agent']['url']}#{zipname}"
  owner node['dripstat']['owner']
  group node['dripstat']['owner']
end

package "unzip"

execute "unzip -j #{dripstat_zip}" do
  cwd node['dripstat']['home']
  user node['dripstat']['owner']
  creates "#{node['dripstat']['home']}/dripstat.jar"
end

template "#{node['dripstat']['home']}/config.properties" do
  source  'dripstat.properties.erb'
  mode    '0644'
  owner   node['dripstat']['owner']
  group   node['dripstat']['owner']
end
