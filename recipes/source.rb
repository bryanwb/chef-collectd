#
# Cookbook Name:: collectd
# Recipe:: source
#
# Copyright 2012, Bryan W. Berry
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'ark'

node.set['collectd']['base_dir'] = '/opt/collectd'
node.set['collectd']['plugin_dir'] = '/opt/collectd/lib/collectd'
node.set['collectd']['types_db'] = ['/opt/collectd/share/collectd/types.db']

if platform_family? 'debian'
  package 'perl-modules'
elsif platform_family? 'rhel'
  package 'lm_sensors-devel'
  package 'net-snmp-devel'
  package 'OpenIPMI-devel'
  if node['platform_version'].to_i > 5
    package 'perl-ExtUtils-MakeMaker'
  end
end

# install deps for compiled plugins if there are any
unless node['collectd']['compiled_plugins'].empty?
  include_recipe 'collectd::compiled_plugins'
end

ark 'collectd' do
  url node['collectd']['source_url']
  checksum node['collectd']['checksum']
  version node['collectd']['version']
  prefix_root '/opt'
  prefix_home '/opt'
end

# action [ :configure, :install_with_make ]
cflags = node['collectd']['cflags'].join(' ')

bash 'configure collectd' do
  cwd  "/opt/collectd-#{node['collectd']['version']}"
  code <<EOF
  ./configure #{cflags}
EOF
  not_if { ::File.exists? '/opt/collectd/config.status' }
end

bash 'make and install' do
  cwd  '/opt/collectd'
  code "
  make && make install
"
  not_if { ::File.exists? "/opt/collectd-#{node['collectd']['version']}/sbin/collectd" }
end

link '/usr/sbin/collectd' do
  to '/opt/collectd/sbin/collectd'
end

if node['platform_version'].to_i < 6 && platform_family?('rhel')
  template '/etc/init.d/collectd' do
    source 'collectd.init.el.erb'
    owner 'root'
    group 'root'
    mode 00755
    notifies :restart, 'service[collectd]'
  end
else
  template '/etc/init/collectd.conf' do
    source 'collectd.upstart.conf.erb'
    owner 'root'
    group 'root'
    mode 00755
    notifies :restart, 'service[collectd]'
  end
end
