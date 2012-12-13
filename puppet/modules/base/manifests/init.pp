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
        require => [Package['nfs-common'],Exec['apt-update']],
        source  => "puppet:///modules/base/idmapd.conf",
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
        require => Package['libvirt-bin'],
        source  => "puppet:///modules/base/libvirtd.conf",
      }

      file { 'libvirt-bin':
        path   => '/etc/default/libvirt-bin',
        ensure  => file,
        require => Package['libvirt-bin'],
        source  => "puppet:///modules/base/libvirt-bin",
      }


      package { 'zookeeper-bin':
        ensure => 'installed'
      }

      package { 'zookeeperd':
        ensure => 'installed'
      }
      
    }
