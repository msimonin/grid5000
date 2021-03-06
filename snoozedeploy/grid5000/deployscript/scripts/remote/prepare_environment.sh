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

scriptpath=$(dirname $0)
source $scriptpath/environment.sh

# Create image, template and log directories

if [ ! -d $images_directory ]; then
    mkdir -p $images_directory
fi

if [ ! -d $templates_directory ]; then
    mkdir -p $templates_directory
fi 

if [ ! -d $logs_directory ]; then
    mkdir -p $logs_directory
fi

if [ ! -d $tmp_directory ]; then
    mkdir -p $tmp_directory
fi

#creation user / group
groupadd $group
useradd -s /bin/false $user -g $group
adduser $user libvirtd

chown -R $user:$group $directory

exit 0
