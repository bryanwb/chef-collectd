# this recipe installs development packages required at 
# compile-time for certain plugins

node[:collectd][:compiled_plugins].each do |plugin|
  case plugin
  when /postgres/  # cuz everybody spells it different
    if platform_family? "rhel"
      pkg_version = node['postgresql']['version'].split('.').join('')
      package "postgresql#{pkg_version}-devel"
    elsif platform_family? "debian"
      package "postgresql-server-dev-#{node['postgresql']['version']}"
    end
  when "python"
    if platform_family? "rhel"
      package "python-devel"
    elsif platform_family? "debian"
      package "python-dev"
    end
  end
end
