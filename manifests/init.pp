# == Class: confluent_kafka
#
# Used to setup, install and intialize a Kafka broker
#
# === Parameters
#
# [*apt_key_id*]
#   The GPG key ID for the apt repository. Only used if manage_repo is true.
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

class confluent_kafka (
  $app_log_dir       = $confluent_kafka::params::app_log_dir,
  $apt_key_id        = $confluent_kafka::params::apt_key_id,
  $brokers           = $confluent_kafka::params::brokers,
  $install_java      = $confluent_kafka::params::install_java,
  $install_service   = $confluent_kafka::params::install_service,
  $jmx_opts          = $confluent_kafka::params::jmx_opts,
  $jvm_heap_mem      = $confluent_kafka::params::jvm_heap_mem,
  $jvm_perf_opts     = $confluent_kafka::params::jvm_perf_opts,
  $kafka_config      = $confluent_kafka::params::kafka_config_defaults,
  $log_dirs          = $confluent_kafka::params::log_dirs,
  $log4j_opts        = $confluent_kafka::params::log4j_opts,
  $manage_repo       = $confluent_kafka::params::manage_repo,
  $manage_service    = $confluent_kafka::params::manage_service,
  $package_name      = $confluent_kafka::params::package_name,
  $platform_version  = $confluent_kafka::params::platform_version,
  $restart_on_change = $confluent_kafka::params::restart_on_change,
  $scala_version     = $confluent_kafka::params::scala_version,
  $service_name      = $confluent_kafka::params::service_name,
  $version           = $confluent_kafka::params::version,
  $zk_chroot         = $confluent_kafka::params::zk_chroot,
  $zk_hosts          = $confluent_kafka::params::zk_hosts,
) inherits confluent_kafka::params {
  # Verification
  validate_array($log_dirs)
  validate_array($zk_hosts)
  validate_hash($brokers)
  validate_hash($kafka_config)

  $zk_string = join([join($confluent_kafka::zk_hosts, ','), $confluent_kafka::zk_chroot])

  class { 'confluent_kafka::install': }
  -> class { 'confluent_kafka::config': }
  -> class { 'confluent_kafka::service': }
  -> Class['confluent_kafka']
}
