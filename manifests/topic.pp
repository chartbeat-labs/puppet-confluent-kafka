# == Type confluent_kafka::topic
#
# This class is called from confluent_kafka for service config.
#
# === Parameters
#
# [*ensure*]
#   Ensure topic exists or is deleted, must have delete.topc.enable set to
#   true for deletions to work
#
# [*repliction_factor*]
#   Set replication factor for topic created
#
# [*partitions*]
#   Set number of partitions for topic
#
# [*config*]
#   Hash of custom config overrides to pass into creating topic
#
define confluent_kafka::topic(
  $ensure             = 'present',
  $replication_factor = 2,
  $partitions         = 1,
  $config             = undef,
) {

  $cmd = "/usr/bin/kafka-topics --zookeeper ${::confluent_kafka::zk_string}"

  if $config {
    validate_hash($config)
    $custom_config = inline_template('<% @config.each do |key, value|%> --config <%= key %>=<%= value %><% end %>')
  }
  else {
    $custom_config = ''
  }

  case $ensure {
    'present': {
      exec { "topic_${name}":
        command => "${cmd} --create --topic ${name} --partitions ${partitions} --replication-factor ${replication_factor} ${custom_config}",
        unless  => "${cmd} --list | grep -x ${name}"
      }
    }
    # Will only work of delete.topic.enable is set to True in config
    'absent': {
      exec { "topic_${name}":
        command => "${cmd} --delete --topic ${name}",
        onlyif  => "${cmd} --list | grep -x ${name}"
      }
    }
    default: {

    }
  }

}
