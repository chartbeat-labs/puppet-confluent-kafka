# == Class confluent_kafka::config
#
# This class is called from confluent_kafka for service config.
#
class confluent_kafka::config {
  $notify_service = $confluent_kafka::restart_on_change ? {
    true  => [Confluent_kafka::Service[$confluent_kafka::params::service_name], Exec['validate_config']],
    false => Exec['validate_config'],
  }

}
