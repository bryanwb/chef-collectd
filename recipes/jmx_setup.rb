#
# Cookbook Name:: collectd
# Recipe:: jmx_setup
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

# the configure script fails unless JAVA_HOME terminates with "/"
# super weird!

if ENV['JAVA_HOME']
  java_home = ENV['JAVA_HOME'].dup
  java_home = "#{java_home}/" unless java_home[-1] == '/'
elsif node['java']['java_home']
  java_home = node['java']['java_home'].dup
  java_home = "#{java_home}/" unless java_home[-1] == '/'
else
  Chef::Application.fatal!("Can't find JAVA_HOME, bailing out")
end
  
bash "recompile-collectd" do
  code <<-EOF
  cd /opt/collectd
  ./configure #{node[:collectd][:cflags].join(' ')} --with-java=#{java_home}
  make
  make install
EOF
  not_if { ::File.exists? "#{node[:collectd][:plugin_dir]}/java.so" }
end

template '/etc/collectd/plugins/generic_jmx_types.db' do
  source 'generic_jmx_types.db.erb'
  mode 00644
  notifies :restart, 'service[collectd]'
end
