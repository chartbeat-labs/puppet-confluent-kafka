# == Class confluent_kafka::install
#
# This class is called from confluent_kafka for install.
#
class confluent_kafka::install {
  case $::osfamily {
    'Debian': {
      if $::confluent_kafka::manage_repo {
        include apt
        apt::source { 'confluent':
          location          => 'http://packages.confluent.io/deb/1.0',
          release           => 'stable main',
          architecture      => 'all',
          repos             => '',
          required_packages => 'debian-keyring debian-archive-keyring',
          key               => {
            'id'            => '1A77041E0314E6C5A486524E670540C841468433',
            'source'        => 'http://packages.confluent.io/deb/1.0/archive.key',
          },
          include           => {
            'deb'           => true,
            'src'           => false,
          },
        }
      }
    }
  }

  if $::confluent_kafka::install_java {
    class { 'java':
      distribution => 'jdk',
    }
  }

  package { "${::confluent_kafka::package_name}-${::confluent_kafka::scala_version}":
    ensure => $::confluent_kafka::version,
  }

  group { 'kafka':
    ensure => present,
  }

  user { 'kafka':
    ensure  => present,
    shell   => '/bin/false',
    require => Group['kafka'],
  }

  if $::confluent_kafka::install_service {
    file { "/etc/init.d/${::confluent_kafka::service_name}":
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/confluent_kafka/kafka.init',
    }
  }

}
