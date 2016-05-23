# Crams API server install and configuration
class crams::api (
  $host='localhost',
  $port=80,
  $admin_email='root@localhost') inherits crams
{

  package {'crams-api':
    ensure => installed,
  }

  file {'/etc/crams/settings.py':
    owner   => root,
    group   => root,
    mode    => '0600',
    content => template('crams/api/settings.erb'),
    require => Package['crams-api'],
  }
}
