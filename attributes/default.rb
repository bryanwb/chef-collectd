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

default['collectd']['base_dir'] = "/var/lib/collectd"
default['collectd']['plugin_dir'] = "/usr/lib/collectd"
default['collectd']['types_db'] = ["/usr/share/collectd/types.db"]
default['collectd']['interval'] = 10
default['collectd']['read_threads'] = 5
default['collectd']['install_method'] = "package"
default['collectd']['collectd_web']['path'] = "/srv/collectd_web"
default['collectd']['collectd_web']['hostname'] = "collectd"
default['collectd']['source_url'] = 'http://collectd.org/files/collectd-5.1.2.tar.bz2'
default['collectd']['checksum'] = 'e280932198b91703c2c7daae4dc21cd1ccc94449d23e4a23f4b1ad4bf0e61de2'
default['collectd']['base_plugins'] = %w{cpu interface load memory network df disk}

default['collectd']['graphite']['host'] = "localhost"
default['collectd']['graphite']['port'] = 2003
default['collectd']['graphite']['prefix'] = "collectd."
default['collectd']['graphite']['postfix'] = ""
default['collectd']['graphite']['escape_character'] = "_"
default['collectd']['graphite']['store_rates'] = false
default['collectd']['graphite']['separate_instances'] = false
default['collectd']['compiled_plugins'] = []
default['collectd']['cflags'] = []

default['collectd']['postgresql']['host'] = "localhost"
default['collectd']['postgresql']['port'] = 5432
default['collectd']['postgresql']['username'] = ""
default['collectd']['postgresql']['password'] = ""

default['collectd']['jmx'] = { 'user' => '', 'password' => '' }

default['collectd']['haproxy']['stats_socket'] = "/var/lib/haproxy/stats"

