# == Class: confluent_kafka
#
# Full description of class confluent_kafka here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class confluent_kafka (
  $package_name = $::confluent_kafka::params::package_name,
  $service_name = $::confluent_kafka::params::service_name,
  $brokers           = $::confluent_kafka::params::brokers,
  $scala_version     = $::confluent_kafka::params::scala_version,
  $version           = $::confluent_kafka::params::version,
  $install_java      = $::confluent_kafka::params::install_java,
  $restart_on_change = $::confluent_kafka::params::restart_on_change,
  $manage_service    = $::confluent_kafka::params::manage_service,
  $kafka_config      = $::confluent_kafka::params::config,
  $zk_hosts          = $::confluent_kafka::params::zk_hosts,
  $zk_chroot         = $::confluent_kafka::params::zk_chroot,

) inherits ::confluent_kafka::params {

  # validate parameters here
  $zk_string = join( [join($zk_hosts, ','), $zk_chroot] )
  $tmp_config = {
    'zookeeper.connect' => $zk_string,
  }

  $config = merge($kafka_config, $zk_string)



  class { '::confluent_kafka::install': } ->
  class { '::confluent_kafka::config': } ~>
  class { '::confluent_kafka::service': } ->
  Class['::confluent_kafka']
}
