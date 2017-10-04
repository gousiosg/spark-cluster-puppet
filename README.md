# Spark cluster configuration

Configuration for the Spark cluster configuration used in the Big Data
Processing course at TU Delft. This is probably not reusable as
is, but with small obvious changes in the Puppet configuration
file, you can use it to setup a cluster in a matter of a couple of hours.

A Spark cluster assumes:

* 1 node that will act as the master
* >2 nodes that will act as slaves/workers

The Puppet script will install:

* Spark 2.2, on all nodes
* Hadoop 2.7, mainly for HDFS, on all nodes
* Jupyter, proxied by nginx, on the master
