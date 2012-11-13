
%w{ java-1.6.0-openjdk java-1.6.0-openjdk-devel }.each do |pkg|
  package pkg do
    notifies :run, resources("ruby_block[reset-java-alternatives]"), :delayed
  end
end

ruby_block "reset-java-alternatives" do
  block do
    ::Dir["#{node['java']['java_home']}/bin/*"].each do |bin_cmd|
      cmd_name = ::Dir.basename bin_cmd
      java_home = node['java']['java_home']
      cmd = Chef::ShellOut.new(
                               %Q[ update-alternatives --install /usr/bin/#{cmd_name} #{cmd_name} #{bin_cmd};
                                   update-alternatives --set #{cmd_name} #{bin_cmd} ]
                               )
    end
  end
  action :nothing
end

bash "recompile-collectd" do
  code <<-EOF
  cd /opt/collectd
  ./configure
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
