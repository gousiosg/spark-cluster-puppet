# (c) 2017 - onwards Georgios Gousios <gousiosg@gmail.com>
#
# Various commands to setup the BDP cluster
#

# NOT MEANT TO BE RUN AS A SCRIPT

# On the master node
## Install and config puppet
sudo apt-get install puppet git curl screen software-properties-common build-essential pssh
git@github.com:gousiosg/pi-spark-cluster-puppet.git cluster
sudo gem install librarian-puppet

cd cluster
librarian-puppet install
sudo puppet apply nodes.pp

for n in `cat files/slaves`; do
  ssh-copy-id gousiosg@$n
done

# On each puppet node
sudo apt-get install puppet git curl screen software-properties-common build-essential pssh
