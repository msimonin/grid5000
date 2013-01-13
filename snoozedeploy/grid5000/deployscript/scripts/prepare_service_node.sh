#!/bin/bash
#
# Copyright (C) 2011-2012 Eugen Feller, INRIA <eugen.feller@inria.fr>
# Matthieu Simonin
# This file is part of Snooze. Snooze is free software: you can
# redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, version 2.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA
#

# Copy and install packages


prepare_service_node()
{
 
  copy_and_deploy_keys

  install_taktuk
 
  copy_files 
  
  echo "$log_tag +------------------------------------------------"
  echo "$log_tag | Service node is : `cat $tmp_directory/service_node.txt `"
  echo "$log_tag +------------------------------------------------"
  

}

generate_keys()
{
   echo "$log_tag generating keys"
   rm -rf $tmp_directory/keys
   mkdir -p $tmp_directory/keys
   ssh-keygen -t rsa -f $tmp_directory/keys/hosts_keys -N ''
}

deploy_keys(){
   echo "$log_tag deploying keys"
   for host in $(cat $tmp_directory/hosts_list.txt)
   do
      echo "$log_tag deploying on $host"
      scp $tmp_directory/keys/hosts_keys.pub root@$host:/root/.ssh/id_rsa.pub
      scp $tmp_directory/keys/hosts_keys root@$host:/root/.ssh/id_rsa
      cat $tmp_directory/keys/hosts_keys.pub > $tmp_directory/keys/authorized_keys
      scp $tmp_directory/keys/authorized_keys root@$host:/root/.ssh/tmp_key_file
      ssh root@$host "cat /root/.ssh/tmp_key_file >> /root/.ssh/authorized_keys; rm /root/.ssh/tmp_key_file"
   done
}

copy_and_deploy_keys()
{

   generate_keys
  
   deploy_keys
   
   nb_hosts=`cat $tmp_directory/hosts_list.txt | wc -l`
   service_node=` head -n 1 $tmp_directory/hosts_list.txt `
   echo $service_node > $tmp_directory/service_node.txt
   tail -n $(($nb_hosts-1)) $tmp_directory/hosts_list.txt > $tmp_directory/hosts_list.txt2
   mv $tmp_directory/hosts_list.txt2 $tmp_directory/hosts_list.txt      
 
}

install_taktuk(){
 echo "$log_tag Installing packages on all hosts"
 run_taktuk "$tmp_directory/service_node.txt" exec "[ apt-get install -y taktuk ]"
}

copy_files(){
   #rsync 
}

