
node default {

  Class['libvirt'] -> Class['snoozesetup']
  Class['snoozesetup'] -> Class['nfs']

  include apt
  include libvirt
  include nfs
  include java 
  include zookeeper
  include kadeploy3
  include snoozesetup
}
