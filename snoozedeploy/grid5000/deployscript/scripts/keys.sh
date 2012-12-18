#!/bin/bash



generate_keys()
{
   echo "generating keys"
   rm -rf $tmp_directory/keys
   mkdir -p $tmp_directory/keys
   ssh-keygen -t rsa -f $tmp_directory/keys/hosts_keys -N ''
}

deploy_keys(){
   echo "deploying keys"
   for host in $(cat $tmp_directory/hosts_list.txt)
   do
      echo "deploying on $host"
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
   echo "SERVICE NODE IS : $service_node"
 
}
   
