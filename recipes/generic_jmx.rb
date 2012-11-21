# the configure script fails unless JAVA_HOME terminates with "/"
# super weird!
java_home = ENV['JAVA_HOME'].dup
java_home = "#{java_home}/" unless java_home[-1] == '/'
  
bash "recompile-collectd" do
  code <<-EOF
  cd /opt/collectd
  ./configure #{node[:collectd][:cflags].join(' ')} --with-java=#{java_home}
  make
  make install
EOF
  not_if { ::File.exists? "#{node[:collectd][:plugin_dir]}/java.so" }
end

template "/etc/collectd/plugins/generic_jmx.conf" do
  source "generic_jmx.conf.erb"
  mode "0644"
  notifies :restart, resources(:service => "collectd")
end

template "/etc/collectd/plugins/generic_jmx_types.db" do
  source "generic_jmx_types.db.erb"
  mode "0644"
  notifies :restart, resources(:service => "collectd")
end
