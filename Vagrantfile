# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Number of cluster nodes (excluding the storm master server)
    cluster_size = 2
    # Base ip to use, master will have a 0 appended and then each node will add its number to it (1,2,3,4...)
    base_ip = '192.168.0.1'
    boxCentOS7 = 'puppetlabs/centos-7.0-64-puppet-enterprise'
    # Machine names will be a composition of the node_base_name, it's node number, and the domain_subfix
    node_base_name = "node-"
    domain_subfix = ".cluster"

    # The master will have a simple name, plus the domain_subfix
    master_hostname = 'storm-master'
    master_fqdn = master_hostname + domain_subfix

    # The path where files are shared between machines
    sharePath = '/mnt/vshare'
    # The puppet folder needs to be shared explicitly for the provisioning to work
    config.vm.synced_folder 'puppet', '/puppet'
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder 'share', sharePath, create: true

    # Master node provisioning.
    config.vm.define master_fqdn, primary: true do |stormmasterserver|
      stormmasterserver.vm.box = boxCentOS7
      stormmasterserver.vm.hostname = master_fqdn
      stormmasterserver.vm.network :private_network, ip: base_ip + '0'
#      stormmasterserver.vm.network :forwarded_port, guest: 8080, host: 8080

      stormmasterserver.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 1024]
      end

      stormmasterserver.vm.provision :puppet do |puppet|
        puppet.manifests_path   = 'puppet/manifests'
        puppet.module_path      = 'puppet/modules'
        puppet.manifest_file    = 'storm.pp'
        puppet.options          = '--verbose'
        puppet.facter           = {
            'master_hostname'     => master_hostname,
            'master_fqdn'         => master_fqdn,
            'node_base_name'      => node_base_name,
            'domain_subfix'       => domain_subfix,
            'base_ip'             => base_ip,
            'cluster_size'        => cluster_size,
        }
      end
    end

#=begin
  # Nodes provision
  1.upto(cluster_size) do |index|
    node_name = node_base_name + index.to_s + domain_subfix

    config.vm.define node_name do |node|
      node.vm.box = boxCentOS7
      node.vm.hostname = node_name
      node.vm.network :private_network, ip: base_ip + index.to_s
      node.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 2024]
      end

      # start the actual provisioning
      node.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'puppet/manifests'
        puppet.manifest_file  = 'storm.pp'
        puppet.module_path    = 'puppet/modules'
        puppet.options        = '--verbose'
        puppet.facter         = {
          'slave_node_index'    => index,
          'master_hostname'     => master_hostname,
          'master_fqdn'         => master_fqdn,
          'node_base_name'      => node_base_name,
          'domain_subfix'       => domain_subfix,
          'base_ip'             => base_ip,
          'cluster_size'        => cluster_size,
        }
      end
    end # node
  end # nodes provision
#=end
end
