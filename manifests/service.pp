# == Class confluent_kafka::service
#
# This class is meant to be called from confluent_kafka.
# It ensures the service is running.
#
class confluent_kafka::service {
  $manage_service_ensure = $::confluent_kafka::manage_service ? {
    true    => 'running',
    false   => undef,
    default => undef,
  }

  if $::confluent_kafka::manage_service {
    service { $::confluent_kafka::service_name:
      ensure     => $manage_service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
