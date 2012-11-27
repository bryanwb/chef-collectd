include_recipe "collectd::jmx_setup"

if !Chef::Config[:solo] && node['collectd']['jmx']['authenticate'] == true
  jmx_creds = Chef::EncryptedDataBagItem.load('stash', 'jmx')
  node['collectd']['jmx']['user'] = jmx_creds['user']
  node['collectd']['jmx']['password'] = jmx_creds['password']
end

template "/etc/collectd/plugins/generic_jmx.conf" do
  source "generic_jmx.conf.erb"
  mode "0644"
  notifies :restart, resources(:service => "collectd")
  variables( :user => node['collectd']['jmx']['user'],
             :password => node['collectd']['jmx']['password'] )
end

