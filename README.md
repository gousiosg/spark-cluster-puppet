# Spark cluster configuration

Configuration for the Spark cluster configuration used in the TI2736-B [Big Data
Processing](http://gousios.org/courses/bigdata/course_descr.nb.html) course at
TU Delft. This is probably not reusable as is, but with small obvious changes in
the Puppet configuration file, you can use it to setup a cluster in a matter of
a couple of hours.

A Spark cluster assumes:

* 1 node that will act as the master (in our case `bdp1.ewi.tudelft.nl`)
* 2 or more nodes that will act as slaves/workers (in our case `bdp[2-5].ewi.tudelft.nl`)

The Puppet script will install:

* Spark 2.2, on all nodes
* Hadoop 2.7, mainly for HDFS, on all nodes
* Jupyter, proxied by nginx, on the master
* Apache Toree, as a driver for Spark on Jupyter

The code assumes that the VMs already have an IP/DNS name and that they run
Ubuntu 16.04 server. The file `spark-cluster.sh` contains some setup work that
needs to take place on each node.

Then, you can run the `sync-cluster.sh` script to copy the Puppet configuration
on each worker and run `puppet apply` to apply it.

The following files contain TU Delft specific information, mostly node names.
You probably need to change them.

```
files/bdp1.ewi.tudelft.nl.conf
files/core-site.xml
files/hosts
files/masters
files/slaves
files/spark-slaves
files/yarn-site.xml
monitor
nodes.pp
tmux/tmux-monitor.conf
```
