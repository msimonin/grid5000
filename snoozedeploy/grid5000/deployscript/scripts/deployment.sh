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

## Deploys the image
deploy_image_vlan () {
    echo "$log_tag Starting image deployment on all hosts"

    local job_id=$(get_job_id)
    if [ -z "$job_id" ];
    then
        echo "$log_tag Did you connect to your job?!"
        return $error_code
    fi
    
    local virtual_machine_subnet=$(get_virtual_machine_subnet $job_id)
    if [ -z "$virtual_machine_subnet" ];
    then
        echo "$log_tag You must have a reservation with a subnet reserved!"
        return $error_code
    fi

    create_hosts_list_vlan $job_id
    ## Matt : ajout du deploiement multi site
    kadeploy3 -e ubuntu-x64-br -u sbadia -f $tmp_directory/full_hosts_list.txt  -o $tmp_directory/nodes_deployed.txt --multi-server --vlan `kavlan -V` -k 

    if [[ $? -ne $success_code ]]
    then
        echo "$log_tag Did you connect to your job?!"
        return $error_code
    fi
    
    return $success_code
}


deploy_image_no_vlan () {
    echo "$log_tag Starting image deployment on all hosts"

    local job_id=$(get_job_id)
    if [ -z "$job_id" ];
    then
        echo "$log_tag Did you connect to your job?!"
        return $error_code
    fi

    local virtual_machine_subnet=$(get_virtual_machine_subnet $job_id)
    if [ -z "$virtual_machine_subnet" ];
    then
        echo "$log_tag You must have a reservation with a subnet reserved!"
        return $error_code
    fi

    create_hosts_list_no_vlan $job_id
    $katapult_command -a $environment_location/$environment_name -f $tmp_directory/hosts_list.txt -l $USER --max-deploy-runs $max_deploy_runs --min-deployed-nodes $(get_total_cluster_size)
    if [[ $? -ne $success_code ]]
    then
        echo "$log_tag Did you connect to your job?!"
        return $error_code
    fi

    return $success_code
}

