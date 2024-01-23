# == Class confluent_kafka::install
#
# This class is called from confluent_kafka for install.
#

class confluent_kafka::install {
  case $facts['os']['family'] {
    'Debian': {
      if $confluent_kafka::manage_repo {
        include apt
        ensure_packages(['debian-keyring', 'debian-archive-keyring'])
        apt::source { 'confluent':
          location     => "http://packages.confluent.io/deb/${confluent_kafka::platform_version}",
          release      => 'stable',
          architecture => 'amd64',
          repos        => 'main',
          notify       => Exec['apt-update'],
          require      => [
            Package['debian-keyring'],
            Package['debian-archive-keyring'],
          ],
          key          => {
            'id'     => $confluent_kafka::apt_key_id,
            'source' => "http://packages.confluent.io/deb/${confluent_kafka::platform_version}/archive.key",
          },
          include      => {
            'deb' => true,
            'src' => false,
          },
        }
      }
    }
  }

  exec { 'apt-get update':
    command     => '/usr/bin/apt-get update',
    alias       => 'apt-update',
    refreshonly => true,
  }

  if $confluent_kafka::install_java {
    class { 'java':
      distribution => 'jdk',
    }
  }

  case versioncmp($confluent_kafka::platform_version, '6.0') {
    -1: { $_pkg_name = "${confluent_kafka::package_name}-${confluent_kafka::scala_version}" }
    default: { $_pkg_name = $confluent_kafka::package_name }
  }

  package { $_pkg_name:
    ensure  => $confluent_kafka::version,
    require => Exec['apt-update'],
  }

  group { 'kafka':
    ensure => present,
  }

  user { 'kafka':
    ensure  => present,
    shell   => '/bin/false',
    require => Group['kafka'],
  }

  if $confluent_kafka::install_service {
    file { "/etc/init.d/${confluent_kafka::service_name}":
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/confluent_kafka/kafka.init',
    }
  }
}
