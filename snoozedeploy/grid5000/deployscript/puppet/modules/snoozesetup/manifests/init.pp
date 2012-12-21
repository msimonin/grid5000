class snoozesetup {
  user { 'snoozeadmin':
    ensure => "present",
    groups  => ["snooze", "libvirtd"],
    require => [Group["snooze"],Group["libvirtd"]]
  }

  group { 'snooze':
    ensure     => "present"
  }

  group { 'libvirtd':
    ensure     => "present"
  }

   file { 'snoozeadmin-sudoers':
        path    => '/etc/sudoers.d/snoozeadmin',
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode  => '0440',
        source  => "puppet:///modules/snoozesetup/etc/sudoers.d/snoozeadmin",
      }


}

