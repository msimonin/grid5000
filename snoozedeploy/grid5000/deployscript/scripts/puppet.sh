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

install_puppet () {
    echo "$log_tag installing puppet"
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ apt-get update ]"   
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ apt-get install -y puppet ]"   
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ mkdir -p $remote_puppet_base ]" 
}

puppet_base_configuration(){
    echo "$log_tag installing base config using puppet"
    put_taktuk "$tmp_directory/hosts_list.txt" "$local_puppet_base/modules" "$remote_puppet_base/modules"
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ puppet apply --modulepath=$remote_puppet_base/modules -e \"include base\" ]" 
}
