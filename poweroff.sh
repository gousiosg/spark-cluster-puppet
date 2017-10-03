#!/usr/bin/env bash

for i in `seq 1 4`;
do
  echo "Shutting down slave$i"
  ssh "slave$i.spark" "sudo poweroff"
done

sudo poweroff
