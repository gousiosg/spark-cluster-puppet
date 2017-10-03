#!/usr/bin/env bash

for i in `seq 1 4`;
do
  echo "Rebooting slave$i"
  ssh "slave$i.spark" "sudo reboot"
done

#sudo reboot
