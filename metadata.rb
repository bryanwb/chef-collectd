name             'collectd'
maintainer       'Noan Kantrowitz'
maintainer_email 'noah@coderanger.net'
name             'collectd'
license          'Apache 2.0'
description      'Install and configure the collectd monitoring daemon'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.4.0'

%w{ debian ubuntu centos scientific amazon oracle redhat fedora }.each do |os|
  supports os
end

depends 'python'
depends 'ark'
