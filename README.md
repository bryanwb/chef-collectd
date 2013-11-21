# DESCRIPTION #

Configure and install the [collectd](http://collectd.org/) monitoring daemon.

# REQUIREMENTS #

* Ubuntu 10.04 / 12.04
* RHEL 5 / 6 (or equivalent)

To use the `collectd::collectd_web` recipe you need the [apache2](https://github.com/opscode/cookbooks/tree/master/apache2) cookbook.

The [collectd_plugins](#) cookbook is not required, but provides many common plugin definitions for easy reuse.

# ATTRIBUTES #

* `default['collectd']['basedir']` - Base folder for collectd output data.
* `default['collectd']['plugin_dir']` - Base folder to find plugins.
* `default['collectd']['types_db']` - Array of files to read graph type information from.
* `default['collectd']['interval']` - Time period in seconds to wait between data reads.
* `default['collectd']['read_threads']` - Number of threads for reading plugins - Defaults to 5
* `default['collectd']['install_method']` - Method to install collectd.  Defaults to package on debian/ubuntu systems and source for all others

* `default['collectd']['source_url']` - URL to download the collectd source from.  Out of the box Chef is blocked from downloading the source package from the collectd.org site.  You'll need to download the file and host it locally.
* `default['collectd']['checksum'] ` - Checksum of the source tar.bz2 file
* `default['collectd']['base_plugins']` - Plugins to load through the `collect::base_plugins` recipe

* `default['collectd']['collectd_web']['path']` - Location to install collectd_web to. Defaults to /srv/collectd_web.
* `default['collectd']['collectd_web']['hostname']` - Server name to use for collectd_web Apache site.
* `default['collectd']['compiled_plugins'] `
* `default['collectd']['cflags']`

* `default['collectd']['collectd_web']['path']` - Path to the collectd_web files.  Defaults to "/srv/collectd_web"
* `default['collectd']['collectd_web']['hostname']` - Hostname for the collectd_web site.  Defaults to "collectd"

* `default['collectd']['graphite']['host']` - FQDN of the graphite server.  Defaults to "localhost"
* `default['collectd']['graphite']['port']` - Port of the Graphite server.  Defaults to 2003
* `default['collectd']['graphite']['prefix']` String to add to the beginning of the metrics name.  Defaults to "collectd." in order to put metrics in a folder called "collectd" on the Graphite server.
* `default['collectd']['graphite']['postfix']` String to add to the metric name.  No default
* `default['collectd']['graphite']['escape_character']` Character to replace periods in metric names with.  Defaults to "_" changing node fqdns to myserver_mydomain_com
* `default['collectd']['graphite']['store_rates']` Store rates of change or total values. Defaults to "false"
* `default['collectd']['graphite']['separate_instances']` If set to true collectd will separate out metrics with a period to place each metric type in a folder under the node name.  Defaults to "false"

* `default['collectd']['postgresql']['host']` - The fqdn of the postgresql server. Defaults to "localhost"
* `default['collectd']['postgresql']['port']` - The port of the postgresql server. Defaults to "5432"
* `default['collectd']['postgresql']['username']` - The username for accessing the postgresql server.  No Default
* `default['collectd']['postgresql']['password']` - The password for accessing the postgresql server.  No default

* `default['collectd']['haproxy']['stats_socket']` - The stats_socket file used to poll haproxy metrics.  Defaults to "/var/lib/haproxy/stats"

* `default['collectd']['syslog']['log_level']` - Minimum log level to send to syslog. Defaults to "info"

* `default['collectd']['encrypted_databag']` - Data bag containing sensitive data such as jmx username / password. Defaults to "basics"
* `default['collectd']['encrypted_databag_item']` Data bag item containing sensitive data such as jmx username / password.  Defaults to "secrets"

* `default['collectd']['jmx']['ignored_role_strings']` - Array of role suffixes to chop off when searching data bag names.  This allows you to have names like "myservice_iad" and "myservice_sjc" that collapse down to just "myservice" by stripping off "_sjc" and "_iad"

# USAGE #

###collectd::default### 
This recipe installs the collectd daemon.

###collectd::client###
This recipe installs collectd and configures it to send data to a server.  This recipe uses search to find the collectd server.

###collectd::server###
This recipe installs collectd and configures it to recieve data from clients.

###collectd::base_plugins###
This recipe enables all plugins listed in node['collectd']['base_plugins'].  This defaults to cpu, interface, load, memory, network, df, and disk.

###collectd::graphite###
This recipe enables the write_graphite plugin.  There are several graphite specific attributes listed above in the full list of attributes.  You'll most likely need to modify these to get the desired graphite output.

###collectd::syslog###
This recipe enables the syslog plugin and logs at the logging level defined in node['collectd']['syslog']['log_level']

###collectd::apache2###
This recipe enables the apache2 plugin polling mod_status data from http://localhost/server-status?auto

###collectd::nginx###
This recipe enables the ngninx plugin polling mod_status data from http://127.0.0.1/nginx_status

###collectd::sensors###
This recipe enables the sensors plugin. This recipe will perform no actions on virtualized systems or systems running in EC2

###collectd::haproxy###
This recipe enables the haproxy plugin and polls from the stats socket file defined at node['collectd']['haproxy']['stats_socket'].  This plugin requires that collectd have been compiled with python support.

###collectd::memcached###
This recipe enables the memcached plugin and polls data from the memcached instance on port 11211 of the loca system


## Defines ##

Several defines are provided to simplfy configuring plugins

### collectd_plugin ###

The `collectd_plugin` define configures and enables standard collect plugins. Example:

```ruby
collectd_plugin "interface" do
  options :interface=>"lo", :ignore_selected=>true
end
```

The options hash is converted to collectd-style settings automatically. Any symbol key will be converted to camel-case. In the above example :ignore_selected will be output as the
key "IgnoreSelected". If the key is already a string, this conversion is skipped. If the value is an array, it will be output as a separate line for each element.

### collectd_python_plugin ###

The `collectd_python_plugin` define configures and enables Python plugins using the collectd-python plugin. Example:

```ruby
collectd_python_plugin "redis" do
  options :host=>servers, :verbose=>true
end
```

Options are interpreted in the same way as with `collectd_plugin`. This define will not deploy the plugin script as well, so be sure to setup a cookbook_file resource
or other mechanism to handle distribution. Example:

```ruby
cookbook_file File.join(node[:collectd][:plugin_dir], "redis.py") do
  owner "root"
  group "root"
  mode 0644
end
```


## Web frontend ##

The `collectd::collectd_web` recipe will automatically deploy the [collectd_web](https://github.com/httpdss/collectd-web) frontend using Apache. The 
[apache2](https://github.com/opscode/cookbooks/tree/master/apache2) cookbook is required for this and is *not* included automatically as this is an optional
component, so be sure to configure the node with the correct recipes.

# LICENSE & AUTHOR #

Author:: Noah Kantrowitz (<noah@coderanger.net>)  
Author:: Bryan W. Berry (<bryan.berry@gmail.com>)  
Author:: Tim A. Smith (<tsmith@limelight.com>)  
Copyright:: 2010, Atari, Inc  
Copyright:: 2012, Bryan W. Berry  
Copyright:: 2012, Webtrends, Inc.  
Copyright:: 2013, Limelight Networks, Inc.  

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
