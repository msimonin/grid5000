class zookeeper {
  package { 'zookeeper-bin':
    ensure => 'installed'
  }

  package { 'zookeeperd':
    ensure => 'installed'
  }
}

