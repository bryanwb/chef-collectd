# Check if collectd was compiled w/ support for the python plugin
# if, not fail loudly
ruby_block "check collectd's python support" do
  block do
    unless ::File.exists? "#{node[:collectd][:plugin_dir]}/python.so"
      Chef::Application.fatal!("collectd does not have python support compiled in. Fix it doofus.")
    end
  end
end

remote_file "#{node[:collectd][:plugin_dir]}/haproxy.py" do
  source "https://github.com/mleinart/collectd-haproxy/blob/master/haproxy.py"
  mode "0644"
  checksum "ae3a035b420c0008aa465c656c13f465fdc327d97c16ba7e93aa980f638be625"
end

template "/etc/collectd/plugins/haproxy.conf" do
  source "haproxy.conf.erb"
  mode "0644"
  notifies :restart, resources(:service => "collectd")
end
