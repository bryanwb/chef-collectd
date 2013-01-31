# Author:: Bryan W. Berry
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

#require 'chef/mixin/language_include_recipe'
include Chef::Mixin::LanguageIncludeRecipe


action :install do

  include_recipe "collectd::jmx_setup"

  template "/etc/collectd/plugins/#{new_resource.name}.conf" do
    source new_resource.template
    owner "root"
    group "root"
    cookbook new_resource.cookbook
    mode 00755
    variables( :port => new_resource.port,
               :user => new_resource.user,
               :password => new_resource.password,
               :tomcat => new_resource.tomcat,
               :jvm_name => new_resource.jvm_name
               )
    notifies :restart, resources(:service => "collectd")
  end
end

action :remove do
  file "/etc/collectd/plugins/#{new_resource.name}.conf" do
    action :delete
  end
end

