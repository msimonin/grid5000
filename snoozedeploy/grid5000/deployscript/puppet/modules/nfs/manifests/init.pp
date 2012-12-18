class nfs {
  package { 'nfs-common':
    ensure => installed,
    require => Exec['apt-get_update']
  }
  
  package { 'nfs-kernel-server':
    ensure => installed,
    require => Exec['apt-get_update']
  }

  
  file { 'idmapd.conf':
    path    => '/etc/idmapd.conf',
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode  => '0644',
    require => [Package['nfs-common']],
    source  => "puppet:///modules/nfs/etc/idmapd.conf",
  }

  service { 'nfs-kernel-server':
    name      => nfs-kernel-server,
    ensure    => running,
    enable    => true,
    subscribe => File['idmapd.conf'],
  }

}
