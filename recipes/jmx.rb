#
# Cookbook Name:: collectd
# Recipe:: jmx
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

include_recipe "collectd::jmx_setup"

if !Chef::Config[:solo] && node['collectd']['jmx']['authenticate'] == true
  jmx_creds = Chef::EncryptedDataBagItem.load('stash', 'jmx')
  node['collectd']['jmx']['user'] = jmx_creds['user']
  node['collectd']['jmx']['password'] = jmx_creds['password']
end

template "/etc/collectd/plugins/generic_jmx.conf" do
  source "generic_jmx.conf.erb"
  mode 00644
  notifies :restart, resources(:service => "collectd")
  variables( :user => node['collectd']['jmx']['user'],
             :password => node['collectd']['jmx']['password'],
             :jvm_name => "")
end

