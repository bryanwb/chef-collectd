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
  mode "0644"
end

template "/etc/collectd/plugins/haproxy.conf" do
  source "haproxy.conf.erb"
  mode "0644"
  notifies :restart, resources(:service => "collectd")
end
