#
# Cookbook Name:: collectd
# Attributes:: default
#
# Copyright 2010, Atari, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['collectd']['base_dir'] = '/var/lib/collectd'
default['collectd']['plugin_dir'] = '/usr/lib/collectd'
default['collectd']['types_db'] = %w{ /usr/share/collectd/types.db }
default['collectd']['interval'] = 10
default['collectd']['read_threads'] = 5
case node['platform_family']
when 'debian'
  default['collectd']['install_method'] = 'package'
else
  default['collectd']['install_method'] = 'source'
end
default['collectd']['version'] = '5.4.0'
default['collectd']['source_url'] = "http://collectd.org/files/collectd-#{node['collectd']['version']}.tar.gz"
default['collectd']['checksum'] = 'c434548789d407b00f15c361305766ba4e36f92ccf2ec98d604aab2a46005239'
default['collectd']['base_plugins'] = %w{cpu interface load memory network df disk}
default['collectd']['compiled_plugins'] = %w{ libcurl python }
default['collectd']['cflags'] = []

default['collectd']['collectd_web']['path'] = '/srv/collectd_web'
default['collectd']['collectd_web']['hostname'] = 'collectd'

default['collectd']['graphite']['host'] = 'localhost'
default['collectd']['graphite']['port'] = 2003
default['collectd']['graphite']['prefix'] = 'collectd.'
default['collectd']['graphite']['postfix'] = ''
default['collectd']['graphite']['escape_character'] = '_'
default['collectd']['graphite']['store_rates'] = false
default['collectd']['graphite']['separate_instances'] = false

default['collectd']['postgresql']['host'] = 'localhost'
default['collectd']['postgresql']['port'] = 5432
default['collectd']['postgresql']['username'] = ''
default['collectd']['postgresql']['password'] = ''

default['collectd']['haproxy']['stats_socket'] = '/var/lib/haproxy/stats'

default['collectd']['syslog']['log_level'] = 'info'

default['collectd']['encrypted_databag'] = 'basics'
default['collectd']['encrypted_databag_item'] = 'secrets'

default['collectd']['jmx']['ignored_role_strings'] = %w{ _jobs _ro _sjc _iad _phx }
