# == Class confluent_kafka::config
#
# This class is called from confluent_kafka for service config.
#
class confluent_kafka::config {
  $notify_service = $confluent_kafka::restart_on_change ? {
    true  => Class['confluent_kafka::service'],
    false => undef,
  }

  # validate parameters here
  $tmp_config = {
    'zookeeper.connect' => $::confluent_kafka::zk_string,
    'broker.id'         => $::confluent_kafka::brokers[$::fqdn],
    'log.dirs'          => join($::confluent_kafka::log_dirs, ',')
  }

  $kafka_config = merge($::confluent_kafka::params::kafka_config_defaults, $::confluent_kafka::kafka_config, $tmp_config)

  File {
    owner   => 'kafka',
    group   => 'kafka',
    mode    => '0644',
    notify  => $notify_service,
  }

  if ($::confluent_kafka::params::initstyle == 'init') {
    file { '/etc/default/kafka':
      content => template('confluent_kafka/kafka.defaults.erb'),
    }
  }

  file { '/etc/kafka/server.properties':
    content => template('confluent_kafka/server.properties.erb'),
  }

  file { '/etc/kafka/log4j.properties':
    content => template('confluent_kafka/log4j.properties.erb'),
  }

  file { [$::confluent_kafka::log_dirs, $::confluent_kafka::app_log_dir]:
    ensure => directory,
  }

}
