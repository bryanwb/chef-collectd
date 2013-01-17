#
# Cookbook Name:: collectd
# Recipe:: haproxy
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

# Check if collectd was compiled w/ support for the python plugin
# if, not fail loudly
ruby_block "check collectd's python support" do
  block do
    unless ::File.exists? "#{node[:collectd][:plugin_dir]}/python.so"
      Chef::Application.fatal!("collectd does not have python support compiled in. Fix it doofus.")
    end
  end
end

cookbook_file "#{node[:collectd][:plugin_dir]}/haproxy.py" do
  source "haproxy.py"
  mode 00644
end

template "/etc/collectd/plugins/haproxy.conf" do
  source "haproxy.conf.erb"
  mode 00644
  notifies :restart, "service[collectd]"
end
