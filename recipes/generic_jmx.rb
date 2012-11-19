java_cflags = [
               "--enable-java",
               "JAR=#{node['java']['java_home']}/bin/jar",
               "JAVAC=#{node['java']['java_home']}/bin/javac"
              ]

java_cflags.each do |flag|
  unless  node[:collectd][:cflags].include? flag
    node[:collectd][:cflags] << flag
  end
end

bash "recompile-collectd" do
  code <<-EOF
  cd /opt/collectd
  ./configure #{node[:collectd][:cflags].join(' ')}
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

template "/etc/collectd/plugins/generic-jmx-types.conf" do
  source "generic_jmx_types.db.erb"
  mode "0644"
  notifies :restart, resources(:service => "collectd")
end
