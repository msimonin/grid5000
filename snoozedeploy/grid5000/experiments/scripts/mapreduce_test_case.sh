#!/bin/bash
#
# Copyright (C) 2010-2012 Eugen Feller, INRIA <eugen.feller@inria.fr>
#
# This file is part of Snooze, a scalable, autonomic, and
# energy-aware virtual machine (VM) management framework.
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses>.
#

perform_virtual_cluser_tasks () 
{
    echo "$log_tag Creating virtual cluster, propagating images, and starting"
    prepare_and_create_virtual_cluster $1 $2
    propagate_base_image
    propagate_virtual_cluster $1
    start_virtual_cluster $1
}

configure_mapreduce () 
{
    case "$1" in
    'custom') echo "$log_tag Configuring MapReduce in custom mode"
        $mapreduce_script "custom_mapreduce --data $2 --compute $3"
        ;;
    'default') echo "$log_tag Configuring MapReduce in default mode"
        $mapreduce_script "default_mapreduce --hosts $2"
        ;;
    *) echo "$log_tag Unknown command received!"
       ;;
    esac
}

start_mapreduce_test_case () 
{
    echo "$log_tag Cluster name:"
    read cluster_name
    echo "$log_tag Number of VMs:"
    read number_of_vms

    perform_virtual_cluser_tasks(cluster_name, number_of_vms)
    configure_storage
    
    echo "$log_tag Configuration mode (default, custom):"
    read configuration_mode
    
    generate_virtual_machine_hosts_list
    hosts_list=`cat $virtual_machine_hosts`
    $mapreduce_script "storage --hosts $hosts_list --job_id $mapreduce_storage_jobid"
    configure_mapreduce(configuration_mode, hosts_list)

    echo "$log_tag Benchmark name (e.g. dfsio, dfsthroughput, mrbench, nnbench, pi, terasort, censusdata, censusbench, wikidata, wikibench):"
    read benchmark_name
    $mapreduce_script "--benchmark $benchmark_name --master $master_node"
}
