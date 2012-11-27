require 'berkshelf/vagrant'

Vagrant::Config.run do |config|
  config.vm.host_name = "collectd-vm"
  config.vm.box = "Berkshelf-CentOS-6.3-x86_64-minimal"
  config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"
  config.vm.network :bridged, "33.33.33.10"
  config.ssh.max_tries = 40
  config.ssh.timeout   = 120
  
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      'java' => {
        'install_flavor' => 'oracle' , 
        'oracle' => { 'accept_oracle_download_terms' => true }
      },
      'collectd' => {
        'install_method' => 'source'
      }
    }
    chef.run_list = [
                     "recipe[collectd]",
                     "recipe[java]",
                     "recipe[collectd::jmx]"
                    ]
  end
end

