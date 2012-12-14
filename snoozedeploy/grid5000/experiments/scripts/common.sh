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

# Returns the number of virtual machines
get_number_of_virtual_machines () {
    local number_of_vms=`cat $virtual_machine_hosts | wc -l`
    echo $number_of_vms
}

# Generates the list of virtual machine host address based on the output
generate_virtual_machine_hosts_list () {
    echo "$log_tag Generating the hosts list"
    cat $snoozeclient_output | awk '{print $2}' | egrep "[0-9]{1,}" > $virtual_machine_hosts
}    
