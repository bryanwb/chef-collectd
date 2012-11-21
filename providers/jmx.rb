# Author:: Bryan W. Berry
# Copyright 2012 Apache 2.0

#require 'chef/mixin/language_include_recipe'
include Chef::Mixin::LanguageIncludeRecipe


action :install do

  include_recipe "collectd::generic_jmx_setup"

  template "/etc/collectd/plugins/#{new_resource.name}.conf" do
    source new_resource.template
    owner "root"
    group "root"
    cookbook new_resource.cookbook
    mode 0755
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
    
