#!/usr/bin/env bash

for h in `cat files/slaves`; do rsync --delete -av cluster/ $h:~/cluster/; done
for h in `cat files/slaves`; do ssh -t -t -o StrictHostKeyChecking=no $h 'sudo  puppet apply --modulepath=/home/gousiosg/cluster/modules /home/gousiosg/cluster/nodes.pp'  ; done
