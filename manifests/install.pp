# == Class confluent_kafka::install
#
# This class is called from confluent_kafka for install.
#


class confluent_kafka::install {
  case $::osfamily {
    'Debian': {
      if $::confluent_kafka::manage_repo {
        include apt
        ensure_packages(['debian-keyring', 'debian-archive-keyring'])
        apt::source { 'confluent':
          location          => "http://packages.confluent.io/deb/${::confluent_kafka::platform_version}",
          release           => 'stable',
          architecture      => 'amd64',
          repos             => 'main',
          notify            => Exec[apt-update],
          require           => [
            Package['debian-keyring'],
            Package['debian-archive-keyring'],
          ],
          key               => {
            'id'            => '1A77041E0314E6C5A486524E670540C841468433',
            'source'        => "http://packages.confluent.io/deb/${::confluent_kafka::platform_version}/archive.key",
          },
          include           => {
            'deb'           => true,
            'src'           => false,
          },
        }
      }
    }
  }


  exec { 'apt-get update':
    command     => "/usr/bin/apt-get update",
    alias       => "apt-update",
    refreshonly => true,
  }

  if $::confluent_kafka::install_java {
    class { 'java':
      distribution => 'jdk',
    }
  }

  $_pkg_name = versioncmp($confluent_kafka::platform_version, '6.0') ? {
    -1 => ${confluent_kafka::package_name}-${::confluent_kafka::scala_version},
    default => $confluent_kafka::package_name
  }

  package { $_pkg_name:
    require => Exec[apt-update],
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
