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

# Check if collectd was compiled or packaged w/ support for the python plugin
# if, not fail loudly
ruby_block "check collectd's python support" do
  block do
    unless ::File.exists? "#{node[:collectd][:plugin_dir]}/python.so"
      Chef::Application.fatal!('collectd does not have python support compiled in. Fix it doofus.')
    end
  end
end

# Make sure python is installed
include_recipe 'python::default'

# If we're on Ubuntu 12.04 we need to install Python 2.6 to get python plugin support
if node['platform_version'] == '12.04'

  package 'libdb4.8' do
    action :install
  end

  remote_file "#{Chef::Config[:file_cache_path]}/python2.6_2.6.7-4ubuntu1.1_amd64.deb" do
    source 'http://us.archive.ubuntu.com/ubuntu/pool/main/p/python2.6/python2.6_2.6.7-4ubuntu1.1_amd64.deb'
    notifies :run, 'execute[install_python26]'
    checksum '50a43d88db471d354af50a493f4ef337bb613d46ab62a035609656e7639b84b0'
  end

  remote_file "#{Chef::Config[:file_cache_path]}/python2.6-minimal_2.6.7-4ubuntu1.1_amd64.deb" do
    source 'http://us.archive.ubuntu.com/ubuntu/pool/main/p/python2.6/python2.6-minimal_2.6.7-4ubuntu1.1_amd64.deb'
    notifies :run, 'execute[install_python26]'
    checksum '69b0cc032d3819c0c23ee22fbd1f1bf3b851261ccea1882e16017b3c612df850'
  end

  remote_file "#{Chef::Config[:file_cache_path]}/libpython2.6_2.6.7-4ubuntu1.1_amd64.deb" do
    source 'http://us.archive.ubuntu.com/ubuntu/pool/main/p/python2.6/libpython2.6_2.6.7-4ubuntu1.1_amd64.deb'
    notifies :run, 'execute[install_python26]'
    checksum '05055f057bbfb6b9c2913a835ccd5810d6c2d0921ee80d412fe81a844c089841'
  end

  execute 'install_python26' do
    cwd Chef::Config[:file_cache_path]
    command 'dpkg -i *python2.6*_2.6.7-4ubuntu1.1_amd64.deb'
    notifies :restart, 'service[collectd]'
    action :nothing
  end
end


template "#{node[:collectd][:plugin_dir]}/haproxy.py" do
  source 'haproxy.py.erb'
  mode 00755
  variables(
    :stats_socket => node['collectd']['haproxy']['stats_socket']
  )
  notifies :restart, 'service[collectd]'
end

template '/etc/collectd/plugins/haproxy.conf' do
  source 'haproxy.conf.erb'
  mode 00644
  notifies :restart, 'service[collectd]'
end
