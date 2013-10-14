#
# Cookbook Name:: collectd
# Recipe:: curl_json
#
# Copyright 2013, Limelight Networks
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

# libyajl-dev doesn't exist on centos before 6.  This recipe won't work
unless platform_family?('rhel') && node.platform_version.to_i < 6

  package 'libyajl-dev' do
    action :install
  end

  ports = data_bag_item('services', 'ports')

  curl_data_sources = {}

  DEFAULT_URL_SUFFIX = '/health/metrics'

  # attempt to find a curl_json data bag item for each role on the node. ignore
  # failures.
  node.roles.each do |role|

    # skip this role if it doesn't have a port
    next unless ports['offset'][role]

    # predefine the structure of the connections section
    curl_data_sources[role] = {}
    curl_data_sources[role]['metrics'] = []

    # attempt to load a databag with the name of the role.  Rescue because
    # failure is normal
    begin
      bag = data_bag_item('collectd_metrics', role)['curl_json']

      # if any mbeans are defined in the data bag add them to the single list
      # of mbeans to define
      port = bag['port'] || (ports['offset'][role] + ports['range']['tomcat'])
      url_suffix = bag['url_suffix'] || DEFAULT_URL_SUFFIX.dup
      curl_data_sources[role]['url'] = 'http://localhost:' << port.to_s << url_suffix
      curl_data_sources[role]['metrics'] = bag['metrics'] if (bag['metrics'])
    rescue Exception=>e
    end

      # right now there are no generic metrics, so skip all of this

      #curl_data_sources['connections'][role]['port'] = ports['offset'][role] + ports['range']['jmx']

      # load the generic JMX mbeans like heap and gc that every service gets
      #data_bag_item('curl_json_metrics', '_generic')['mbeans'].each_pair do |key,val|
      #  curl_data_sources['mbeans'][key] = val
      #  curl_data_sources['connections'][role]['mbeans'] << key
      #end
  end

  if curl_data_sources.empty?
    file '/etc/collectd/plugins/curl_json.conf' do
      action :delete
      notifies :restart, "service[collectd]"
    end
  else
    template '/etc/collectd/plugins/curl_json.conf' do
      source 'curl_json.conf.erb'
      mode 00644
      notifies :restart, "service[collectd]"
      variables(
        :curl_data_sources => curl_data_sources
      )
    end
  end
end
