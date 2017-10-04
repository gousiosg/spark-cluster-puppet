class defaults {
  include apt

  exec { "apt-update": command => "/usr/bin/apt-get update" }

  package { 'vim': ensure => present }
  package { 'git-core': ensure => present }
  package { 'curl' : ensure => present }
  package { 'ntp' : ensure => present }
  package { 'dnsutils' : ensure => present }
  package { 'htop' : ensure => present }
  package { 'nmon' : ensure => present }
  package { 'pssh' : ensure => present }
  package { 'python-pip' : ensure => present }
  package { 'python-tk' : ensure => present }
  package { 'gfortran': ensure => present}
  package { 'numpy' : ensure => present, provider => pip }
  package { 'pandas' : ensure => present, provider => pip }
  package { 'matplotlib' : ensure => present, provider => pip }
  package { 'ggplot' : ensure => present, provider => pip }

  apt::ppa { 'ppa:webupd8team/java': }
  exec { 'accept_oracle_java_license':
  	command => 'echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections',
  	path => "/usr/bin/:/bin/",
  	#before => Package["oracle-java8-installer"],
  	logoutput => true,
  }

  # Install the package
  package {['oracle-java8-installer',]:
  	ensure  => installed,
  	require => [
    		apt::ppa['ppa:webupd8team/java'],
    		Exec['accept_oracle_java_license'],
  ]}

  alternatives { 'editor':
    path => '/usr/bin/vim.basic',
  }

  group {'gousiosg': ensure => 'present'}
  user {'gousiosg': ensure => 'present', groups => ['gousiosg', 'sudo']}

  ssh_authorized_key { "ssh-key-gousiosg":
      user  => "gousiosg",
      ensure => present,
      type   => "ssh-rsa",
      key    => "AAAAB3NzaC1yc2EAAAABIwAAAQEAtyYEI3bTfWntzykFiAWXq6yd7jU1w/ON2DtJ8U28wH1nTsy8Y1zR7nWuTbeTHLhWMe4el/cTn/SW6c8WGJGkE8Xkir6Y5XOrJ3BSj/4EwnqnYt8SyM0ZvLo8sDOPqhTkYQhA4ZNUykQJsAvDRMrEvdqsnjuZtqDi/tru8RvPlo/ChmL2CHCcvGyHWsAixCqgUS6cjz+TzuBePpXdYvrTjIY+6GJDLQ4UIpaJcc2iwLoWS4TEbyaPf5+2qNBwZ2/bQC5u2aosVuD9K/q1aRpvNTqil+J2Ip/irimK2tBPLcf5BdLecnxObyx4GiZ49T8T9YghsoM9Z4a56i0kN0DOkQ==",
      name   => "gousiosg@master"
  }

  $spark_dirname = 'spark-2.2.0-bin-hadoop2.7'
  $spark_filename = "${spark_dirname}.tgz"
  $install_path = "/home/gousiosg/"

  archive { $spark_filename:
    ensure => present,
    path   => "/tmp/${spark_filename}",
    source => "https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz",
    extract      => true,
    extract_path => $install_path,
    creates      => "$install_path/$spark_dirname/bin",
    cleanup      => true,
    user          => 'gousiosg',
    group         => 'gousiosg',
  }

  file { '/home/gousiosg/spark':
    ensure => 'link',
    target => "$install_path/$spark_dirname"
  }

  # Instal Hadoop for HDFS
  $hadoop_dirname = 'hadoop-2.7.4'
  $hadoop_filename = "${hadoop_dirname}.tgz"

  archive { $hadoop_filename:
    ensure => present,
    path   => "/tmp/${hadoop_filename}",
    source =>
    "http://apache.40b.nl/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz",
    extract      => true,
    extract_path => $install_path,
    creates      => "$install_path/$hadoop_dirname/bin",
    cleanup      => true,
    user          => 'gousiosg',
    group         => 'gousiosg',
  }

  file { '/home/gousiosg/hadoop':
    ensure => 'link',
    target => "$install_path/$hadoop_dirname"
  }

  file { "/home/gousiosg/hadoop/etc/hadoop/hadoop-env.sh":
    source => "/home/gousiosg/cluster/files/hadoop-env.sh"
  }

  file { "/home/gousiosg/hadoop/etc/hadoop/core-site.xml":
    source => "/home/gousiosg/cluster/files/core-site.xml"
  }

  file { "/home/gousiosg/hadoop/etc/hadoop/hdfs-site.xml":
    source => "/home/gousiosg/cluster/files/hdfs-site.xml"
  }

  file { "/home/gousiosg/hadoop/etc/hadoop/masters":
    source => "/home/gousiosg/cluster/files/masters"
  }

  file { "/home/gousiosg/hadoop/etc/hadoop/slaves":
    source => "/home/gousiosg/cluster/files/slaves"
  }

  file { "/home/gousiosg/hadoop/etc/hadoop/yarn-site.xml":
    source => "/home/gousiosg/cluster/files/yarn-site.xml"
  }

  file { "/home/gousiosg/.profile":
    source => "/home/gousiosg/cluster/files/dotprofile"
  }

  file { "/etc/hosts":
    source => "/home/gousiosg/cluster/files/hosts"
  }

 file { '/usr/bin/pssh':
    ensure => 'link',
    target => "/usr/bin/parallel-ssh"
  }

}

node 'bdp1.ewi.tudelft.nl' {

  include defaults

  # spark configuration for master
  file { "/home/gousiosg/spark/conf/slaves":
    source => "/home/gousiosg/cluster/files/spark-slaves"
  }

  file { "/home/gousiosg/spark/conf/spark-env.sh":
    source => "/home/gousiosg/cluster/files/spark-env-master.sh"
  }

  package { 'scala' : ensure => 'present'}

  package { 'ipython' : ensure => '5.4.0', provider => pip } ->
  package { 'jupyter' : ensure => present, provider => pip } ->

  package { 'nginx' : ensure => present}
  
  file { "/etc/nginx/sites-available/bdp1.ewi.tudelft.nl.conf":
    source => "/home/gousiosg/cluster/files/bdp1.ewi.tudelft.nl.conf"
  }

  file { '/etc/nginx/sites-enabled/bdp1.ewi.tudelft.nl.conf':
    ensure => 'link',
    target => "/etc/nginx/sites-available/bdp1.ewi.tudelft.nl.conf",
  }
}

node /bdp[2-5]\.ewi\.tudelft\.nl/ {
  include defaults

    file { "/home/gousiosg/spark/conf/spark-env.sh":
      source => "/home/gousiosg/cluster/files/spark-env-slave.sh"
    }
}

