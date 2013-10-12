#
# Cookbook Name:: collectd
# Recipe:: jmx
#
# Copyright 2012, Bryan W. Berry
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

include_recipe 'collectd::jmx_setup'

# load the data bag and data bag item that contain the jmx username and password
secret_data = Chef::EncryptedDataBagItem.load(node['collectd']['encrypted_databag'] , node['collectd']['encrypted_databag_item'])

# load the data bag that includes the ports to use
ports = data_bag_item('services', 'ports')

# create the basic structure that will hold the aggregate JMX values of all services on the node
jmx_vals = {
  'connections' => {},
  'mbeans' => {}
}

# attempt to find a JMX data bag item for each role on the node. ignore failures when a role doesn't have a data bag
node.roles.each do |role|

  # see if the role exists in the ports databag
  if ports['offset'][role]

    # predefine the structure of the connections section
    jmx_vals['connections'][role] = {}
    jmx_vals['connections'][role]['mbeans'] = []

    # attempt to load a databag with the name of the role.  Rescue because failure is normal
    begin
      bag = data_bag_item('collectd_metrics', role)['generic_jmx']

      # if any mbeans are defined in the data bag add them to the single list of mbeans to define
      unless bag['mbeans'].empty?
        bag['mbeans'].each_pair do |key, val|
          jmx_vals['mbeans'][key] = val
          jmx_vals['connections'][role]['mbeans'] << key
        end
      end
    rescue Exception=>e
    end

    jmx_vals['connections'][role]['port'] = ports['offset'][role] + ports['range']['jmx']

    # load the generic JMX mbeans like heap and gc that every service gets
    data_bag_item('collectd_metrics', '_generic')['generic_jmx']['mbeans'].each_pair do |key, val|
      jmx_vals['mbeans'][key] = val
      jmx_vals['connections'][role]['mbeans'] << key
    end
  end
end

# if we didn't find any jmx services on the node then delete the plugin config, otherwise create it
if jmx_vals.empty?
  file '/etc/collectd/plugins/generic_jmx.conf' do
    action :delete
    notifies :restart, resources(:service => 'collectd')
  end
else
  template '/etc/collectd/plugins/generic_jmx.conf' do
    source 'generic_jmx.conf.erb'
    mode 00644
    notifies :restart, resources(:service => 'collectd')
    variables(
      :jmx_vals => jmx_vals,
      :jmx_user => secret_data['jmx']['ro_user'],
      :jmx_password => secret_data['jmx']['ro_password']
    )
  end
end
