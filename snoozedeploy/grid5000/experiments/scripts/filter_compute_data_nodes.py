#!/usr/bin/env python

import sys

if len(sys.argv) < 2:
    sys.stderr.write('Usage: ./filter_compute_data_nodes.py file_name\n')
    sys.exit(1)

fd = open(sys.argv[1])
map = {}
lines = fd.readlines()
for content in lines:
     splitted = content.split()
     host = splitted[1]
     if host in map:
        vms = map[host]
        vms.append(splitted[0])
     else:
        vms = [splitted[0]]
        map.update({splitted[1]:vms})

data_nodes, compute_nodes = [], []
for host in map:
    data_nodes.append(map[host][0])
    compute_nodes.extend(map[host][1:])

print "Data nodes: " +  " ".join(data_nodes)
print "Compute nodes: " + " ".join(compute_nodes)
