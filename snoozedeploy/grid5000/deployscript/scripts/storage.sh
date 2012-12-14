#!/bin/bash
#
# Copyright (C) 2011-2012 Eugen Feller, INRIA <eugen.feller@inria.fr>
#
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

# Configures the storage
configure_storage () {
    echo "$log_tag Starting $storage_type storage configuration procedure"

    # Prepares the environment (create snooze directory)
    if [ "$storage_type" == "local" ]; then
        run_taktuk "$tmp_directory/hosts_list.txt" exec "[ $remote_scripts_directory/prepare_environment.sh ]"
        return $?
    fi
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ mkdir -p $remote_scripts_directory ]"
    put_taktuk "$tmp_directory/hosts_list.txt" "$local_scripts_directory/environment.sh" "$remote_scripts_directory/environment.sh"
    put_taktuk "$tmp_directory/hosts_list.txt" "$local_scripts_directory/prepare_environment.sh" "$remote_scripts_directory/prepare_environment.sh"
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ $remote_scripts_directory/prepare_environment.sh ]"
    
    # Starts NFS server configuration
    configure_nfs_server
    
    # Configure and mount the NFS directory on all nodes
    configure_and_mount_nfs_directory
}

# Configures and starts NFS on the nodes
configure_nfs_server () {
    local first_bootstrap_address=$(get_first_bootstrap_address)
    echo "$log_tag Configuring NFS server on the first bootstrap node: $first_bootstrap_address"
    put_taktuk "$tmp_directory/bootstrap_nodes.txt" "$local_scripts_directory/configure_nfs_server.sh" "$remote_scripts_directory/configure_nfs_server.sh"
    run_taktuk_single_machine "$first_bootstrap_address" exec "[ $remote_scripts_directory/configure_nfs_server.sh ]"
}

# Configures NFS and mounts the directory
configure_and_mount_nfs_directory () {
    echo "$log_tag Mounting NFS storage on group managers and local controllers"

    # make the bootstrap address available for gm and lc
    run_taktuk "$tmp_directory/group_managers.txt" exec "[ mkdir -p $remote_tmp_directory ]"
    run_taktuk "$tmp_directory/local_controllers.txt" exec "[ mkdir -p $remote_tmp_directory ]"
    put_taktuk "$tmp_directory/local_controllers.txt" "$tmp_directory/bootstrap_nodes.txt" "$remote_tmp_directory/bootstrap_nodes.txt" 
    put_taktuk "$tmp_directory/group_managers.txt" "$tmp_directory/bootstrap_nodes.txt" "$remote_tmp_directory/bootstrap_nodes.txt" 
    
    run_taktuk "$tmp_directory/group_managers.txt" exec "[ mkdir -p $remote_scripts_directory ]"
    put_taktuk "$tmp_directory/group_managers.txt" "$local_scripts_directory/environment.sh" "$remote_scripts_directory/environment.sh"
#    prepare_remote_environment
    put_taktuk "$tmp_directory/group_managers.txt" "$local_scripts_directory/configure_fstab_and_mount_nfs_directory.sh" "$remote_scripts_directory/configure_fstab_and_mount_nfs_directory.sh"
    run_taktuk "$tmp_directory/group_managers.txt" exec "[ $remote_scripts_directory/configure_fstab_and_mount_nfs_directory.sh ]"

    put_taktuk "$tmp_directory/local_controllers.txt" "$local_scripts_directory/configure_fstab_and_mount_nfs_directory.sh" "$remote_scripts_directory/configure_fstab_and_mount_nfs_directory.sh"

    run_taktuk "$tmp_directory/local_controllers.txt" exec "[ $remote_scripts_directory/configure_fstab_and_mount_nfs_directory.sh ]"
}
