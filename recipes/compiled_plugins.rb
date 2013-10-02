#
# Cookbook Name:: collectd
# Recipe:: compiled_plugins
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

# this recipe installs development packages required at
# compile-time for certain plugins

node[:collectd][:compiled_plugins].each do |plugin|
  case plugin
  when /postgres/  # cuz everybody spells it different
      include_recipe "yumrepo::postgresql"
    if platform_family? 'rhel'
      pkg_version = node['postgresql']['version'].split('.').join('')
      package "postgresql#{pkg_version}-devel"
    elsif platform_family? 'debian'
      package "postgresql-server-dev-#{node['postgresql']['version']}"
    end
  when "python"
    if platform_family? "rhel"
      package "python-devel"
    elsif platform_family? "debian"
      package "python-dev"
    end
  when /libcurl/
    if platform_family? 'rhel'
      package 'curl-devel'
    elsif platform_family? 'debian'
      package 'libcurl-dev'
    end
  end
end
