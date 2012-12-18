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

# Copy and install packages

copy_packages() {
   echo "$log_tag Deploying packages on all hosts"
   put_taktuk "$tmp_directory/hosts_list.txt" "$local_packages_directory" "$remote_packages_directory"
}

install_packages() {
    echo "$log_tag Installing packages on all hosts"
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ dpkg -i --force-all -R $remote_packages_directory/ ]"
}

remove_packages(){
   echo "$log_tag Removing packages on all hosts"
   run_taktuk "$tmp_directory/hosts_list.txt" exec "[ dpkg --purge snoozenode snoozeclient ]"
}

