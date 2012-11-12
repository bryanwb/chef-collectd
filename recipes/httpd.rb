

template "/etc/collectd/plugins/httpd.conf" do
  source "httpd.conf.erb"
  mode "0644"
  notifies :restart, resources(:service => "collectd")
end
