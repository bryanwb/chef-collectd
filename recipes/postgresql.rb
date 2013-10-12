#
# Cookbook Name:: collectd
# Recipe:: postgresql
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

# Check if collectd was compiled w/ support for postgres
# if, not fail loudly
ruby_block 'check pg support' do
  block do
    unless ::File.exists? "#{node[:collectd][:plugin_dir]}/postgresql.so"
      Chef::Application.fatal!('collectd does not have postgresql support compiled in. Fix it doofus.')
    end
  end
end

template '/etc/collectd/plugins/postgresql.conf' do
  source 'postgresql.conf.erb'
  mode 00644
  notifies :restart, 'service[collectd]'
end

file '/etc/collectd/plugins/postgresql-types.db' do
  content <<EOF
pg_lock_count    value:GAUGE:0:U
pg_datname_connections    value:GAUGE:0:U
pg_username_connections   value:GAUGE:0:U
EOF
  mode 00644
end
