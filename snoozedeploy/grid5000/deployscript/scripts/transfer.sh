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

# Transfers backing virtual machine image
transfer_backing_virtual_machine_image () {
    echo "$log_tag Transfering backing virtual machine image"
    echo "$log_tag From $source_images_directory To $destination_images_directory/" 
    transfer_data "$source_images_directory/*" "$destination_images_directory/"
}

# Transfers the experiment script
transfer_experiments_script () {
    echo "$log_tag Transfering the experiments script"
    transfer_data "$source_experiments_script_directory/*" "$destination_experiments_script_directory/"
}

# Transfers data between two hosts
transfer_data () {
    local first_bootstrap_address=$(get_first_bootstrap_address)
    echo "$log_tag Transfering the data to: $first_bootstrap_address"
    
    $rsync_command $rsync_parameters $1 root@$first_bootstrap_address:$2 
    put_taktuk $tmp_directory/bootstrap_nodes.txt "$local_scripts_directory/fix_permissions.sh" "$remote_scripts_directory/fix_permissions.sh"
    run_taktuk_single_machine "$first_bootstrap_address" exec "[ $remote_scripts_directory/fix_permissions.sh ]"
}
