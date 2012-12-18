  class base {
      exec { 'apt-update':
        command => "/usr/bin/apt-get update"
      }

      # nfs
   
      package { 'nfs-common':
        ensure => installed,
      }

      file { 'idmapd.conf':
        path    => '/etc/idmapd.conf',
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode  => '0644',
        require => [Package['nfs-common']],
        source  => "puppet:///modules/base/etc/idmapd.conf",
      }

      package { 'nfs-kernel-server':
        ensure => installed,
      }

      service { 'nfs-kernel-server':
        name      => nfs-kernel-server,
        ensure    => running,
        enable    => true,
        subscribe => File['idmapd.conf'],
      }

      # openjdk 
 
      package { 'openjdk-7-jre':
        ensure => installed,
        require => Exec['apt-update']
      }
   
      # libvirt

      package { 'libvirt-bin':
        ensure => installed,
      }

      package { 'libvirt-dev':
        ensure => installed,
      }

      package { 'qemu-kvm':
        ensure => installed,
      }
      
      service { 'libvirt-bin':
        name      => libvirt-bin,
        ensure    => running,
        enable    => true,
        subscribe => File['libvirtd.conf'],
      }
      
      file { 'libvirtd.conf':
        path    => '/etc/libvirt/libvirtd.conf',
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode  => '0644',
        require => Package['libvirt-bin'],
        source  => "puppet:///modules/base/etc/libvirtd.conf",
      }

      file { 'libvirt-bin':
        path   => '/etc/default/libvirt-bin',
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode  => '0644',
        require => Package['libvirt-bin'],
        source  => "puppet:///modules/base/etc/libvirt-bin",
      }


      package { 'zookeeper-bin':
        ensure => 'installed'
      }

      package { 'zookeeperd':
        ensure => 'installed'
      }

    package {'kadeploy-common':
        provider => dpkg,
        ensure => installed,
        source  => "/root/puppet/modules/base/files/kadeploy-common-3.1.5.3.deb",
        before => Exec['apt-fix']
    }

      package {'kadeploy-client':
         provider => dpkg,
         ensure => installed,
         source  => "/root/puppet/modules/base/files/kadeploy-client-3.1.5.3.deb",
         before => Exec['apt-fix']
    }
    exec { 'apt-fix':
        command => "/usr/bin/apt-get -f -y install"
    }


    file { 'client_conf.yml':
        path    => '/etc/kadeploy3/client_conf.yml',
        ensure  => file,
        owner => 'root',
        group => 'root',
        mode  => '0644',
        require => Package['kadeploy-client'],
        source  => "puppet:///modules/base/client_conf.yml",
      }
}  
