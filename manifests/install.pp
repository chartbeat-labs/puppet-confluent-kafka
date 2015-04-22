# == Class confluent_kafka::install
#
# This class is called from confluent_kafka for install.
#
class confluent_kafka::install {

  package { $::confluent_kafka::package_name:
    ensure => present,
  }
}
