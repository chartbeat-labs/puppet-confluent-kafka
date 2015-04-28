# == Class confluent_kafka::params
#
# This class is meant to be called from confluent_kafka.
# It sets variables according to platform.
#
class confluent_kafka::params {
  $scala_version     = '2.10.4'
  $service_name      = 'kafka'
  $package_name      = "confluent-kafka"
  $version           = '0.8.2.0-1'
  $install_java      = false
  $install_service   = true
  $restart_on_change = false
  $manage_service    = true
  $manage_repo       = true
  $zk_hosts          = ['localhost:2181']
  $zk_chroot         = ''
  $max_nofiles       = '65535'
  $log_dirs          = ['/tmp/kafka-logs']
  $app_log_dir       = '/var/log/kafka'
  $jvm_heap_mem      = '-Xmx1G -Xms1G'
  $jvm_perf_opts     = '-XX:PermSize=48m -XX:MaxPermSize=48m -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35'
  $jmx_opts          = '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.net.preferIPv4Stack=true -Dcom.sun.management.jmxremote.port=9999'
  $log4j_opts        = '-Dlog4j.configuration=file:/etc/kafka/log4j.properties'

  $brokers           = {
      'localhost' => 0,
  }

  $kafka_config_defaults = {
    'broker.id'                                     => '',
    'log.dirs'                                      => $log_dirs,
    'port'                                          => '9092',
    'zookeeper.connect'                             => '',
    'message.max.bytes'                             => '1000000',
    'num.network.threads'                           => '3',
    'num.io.threads'                                => '8',
    'background.threads'                            => '4',
    'queued.max.requests'                           => '500',
    'socket.send.buffer.bytes'                      => '102400',
    'socket.receive.buffer.bytes'                   => '102400',
    'socket.request.max.bytes'                      => '104857600',
    'num.partitions'                                => '1',
    'log.segment.bytes'                             => '1073741824',
    'log.roll.hours'                                => '168',
    'log.cleanup.policy'                            => 'delete',
    'log.retention.hours'                           => '168',
    'log.retention.minutes'                         => '10080',
    'log.retention.bytes'                           => '-1',
    'log.retention.check.interval.ms'               => '300000',
    'log.cleaner.enable'                            => false,
    'log.cleaner.threads'                           => '1',
    'log.cleaner.dedupe.buffer.size'                => '524288000',
    'log.cleaner.io.buffer.size'                    => '524288',
    'log.cleaner.io.buffer.load.factor'             => '0.9',
    'log.cleaner.backoff.ms'                        => '15000',
    'log.cleaner.min.cleanable.ratio'               => '0.5',
    'log.cleaner.delete.retention.ms'               => '86400000',
    'log.index.size.max.bytes'                      => '10485760',
    'log.index.interval.bytes'                      => '4096',
    'log.flush.interval.messages'                   => '10000',
    'log.flush.scheduler.interval.ms'               => '3000',
    'log.flush.interval.ms'                         => '3000',
    'log.delete.delay.ms'                           => '60000',
    'log.flush.offset.checkpoint.interval.ms'       => '60000',
    'auto.create.topics.enable'                     => true,
    'controller.socket.timeout.ms'                  => '30000',
    'controller.message.queue.size'                 => '10',
    'default.replication.factor'                    => '1',
    'replica.lag.time.max.ms'                       => '10000',
    'replica.lag.max.messages'                      => '4000',
    'replica.socket.timeout.ms'                     => '301000',
    'replica.socket.receive.buffer.bytes'           => '641024',
    'replica.fetch.max.bytes'                       => '10241024',
    'replica.fetch.wait.max.ms'                     => '500',
    'replica.fetch.min.bytes'                       => '1',
    'num.replica.fetchers'                          => '1',
    'replica.high.watermark.checkpoint.interval.ms' => '5000',
    'fetch.purgatory.purge.interval.requests'       => '10000',
    'producer.purgatory.purge.interval.requests'    => '10000',
    'zookeeper.session.timeout.ms'                  => '6000',
    'zookeeper.connection.timeout.ms'               => '6000',
    'zookeeper.sync.time.ms'                        => '2000',
    'controlled.shutdown.enable'                    => true,
    'controlled.shutdown.max.retries'               => '3',
    'controlled.shutdown.retry.backoff.ms'          => '5000',
    'auto.leader.rebalance.enable'                  => true,
    'leader.imbalance.per.broker.percentage'        => '10',
    'leader.imbalance.check.interval.seconds'       => '300',
    'offset.metadata.max.bytes'                     => '1024',
    'delete.topic.enable'                           => false,
  }

}
