# == Class: confluent_kafka
#
# Used to setup, install and intialize a Kafka broker
#
# === Parameters
#
# [*package_name*]
#   Base name of the package, we append *scala_version*  to get full name
#
# [*service_name*]
#   Name of the service to install and use
#
# [*brokers*]
#   Hash map hostname to broker id
#
# [*scala_version*]
#   Scala you are using, used to install correct package
#
# [*version*]
#   Version of Kafka to install
#
# [*install_java*]
#   Whether or not we should install java
#
# [*install_service*]
#   Install init script
#
# [*restart_on_change*]
#   Bounce service on confiuration changes
#
# [*manage_service*]
#   Setup init service
#
# [*manage_repo*]
#   Install Confluent Deb repo
#
# [*kafka_config*]
#   Hash map to set any kafka server.properties settings
#
# [*zk_hosts*]
#   List of Zookeeper servers with port numbers
#
# [*zk_chroot*]
#   If you are using a chroot in zookeeper
#
# [*log_dirs*]
#   List where data is stored
#
# [*app_log_dir*]
#   Setup where kafka application logs should goto
#
# [*jvm_heap_mem*]
#   Used for setting -Xmx and -Xms
#
# [*jvm_perf_opts*]
#   Any additional JVM options you want to set
#
# [*jmx_opts*]
#   Setup and configure JMX
#
# [*log4j_opts*]
#   Override Log4J file
#
# [extra_args*]
#   Override Log4J file
#

class confluent_kafka (
  $package_name      = $::confluent_kafka::params::package_name,
  $service_name      = $::confluent_kafka::params::service_name,
  $brokers           = $::confluent_kafka::params::brokers,
  $scala_version     = $::confluent_kafka::params::scala_version,
  $version           = $::confluent_kafka::params::version,
  $install_java      = $::confluent_kafka::params::install_java,
  $install_service   = $::confluent_kafka::params::install_service,
  $restart_on_change = $::confluent_kafka::params::restart_on_change,
  $manage_service    = $::confluent_kafka::params::manage_service,
  $manage_repo       = $::confluent_kafka::params::manage_repo,
  $kafka_config      = $::confluent_kafka::params::kafka_config_defaults,
  $zk_hosts          = $::confluent_kafka::params::zk_hosts,
  $zk_chroot         = $::confluent_kafka::params::zk_chroot,
  $log_dirs          = $::confluent_kafka::params::log_dirs,
  $app_log_dir       = $::confluent_kafka::params::app_log_dir,
  $jvm_heap_mem      = $::confluent_kafka::params::jvm_heap_mem,
  $jvm_perf_opts     = $::confluent_kafka::params::jvm_perf_opts,
  $jmx_opts          = $::confluent_kafka::params::jmx_opts,
  $log4j_opts        = $::confluent_kafka::params::log4j_opts,
  $extra_args        = $::confluent_kafka::params::extra_args,
  $platform_version  = $::confluent_kafka::params::platform_version,

) inherits ::confluent_kafka::params {

  # Verification
  validate_array($log_dirs)
  validate_array($zk_hosts)
  validate_hash($brokers)
  validate_hash($kafka_config)

  $zk_string = join( [join($::confluent_kafka::zk_hosts, ','), $::confluent_kafka::zk_chroot] )

  class { '::confluent_kafka::install': } ->
  class { '::confluent_kafka::config': } ->
  class { '::confluent_kafka::service': } ->
  Class['::confluent_kafka']
}
