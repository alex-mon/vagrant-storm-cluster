# Turn off interfering services
class { 'interfering_services': }
class { 'ntp': }
class { 'jdk_oracle': }

package { 'vim-enhanced': ensure => 'installed' }
package { 'openssh-server': ensure => 'installed' }

hosts::populate { 'add ips to hosts file':
  master_name     => $master_hostname,
  node_base_name  => $node_base_name,
  domain_subfix   => $domain_subfix,
  cluster_size    => $cluster_size,
  base_ip         => $base_ip
}

class {'storm':
  zookeeper_servers    => [ $master_fqdn ],
  install_from_tarball => true,
  version              => "1.0.1",
}

class {'storm::nimbus':
  seeds                 => [ $master_fqdn ],
  manage_service        => true,
  use_systemd_templates => true,
}

if $slave_node_index == undef {

  class{'zookeeper':
    id              => 1,
    install_java    => false,
    manage_firewall => false,
    manage_service  => true,
    servers => {
      1 =>{
        ip => $::fqdn,
        leaderPort => 2888,
        electionPort => 3888
      }
    },
  }

  zookeeper::resource::configuration {$::fqdn:
    ensure           => 'present',
    clientPortAddress => $::fqdn,
  }

  class {'storm::ui':
    use_systemd_templates => true,
    manage_service        => true,
  }

  class {'storm::drpc':
    servers               => [ $::fqdn ],
    use_systemd_templates => true,
    manage_service        => true,
  }
}
else {
  class {'storm::supervisor':
    workers               => 2,
    use_systemd_templates => true,
    manage_service        => true,
  }
}
