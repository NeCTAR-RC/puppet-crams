# Crams API server install and configuration
class crams::api (
  $host='localhost',
  $port=80,
  $crams_email_address='root@localhost',
  $environment,
  $ks_admin_user,
  $ks_admin_pass,
  $ks_admin_tenant,
  $ks_auth_url,
  $allowed_hosts,
  $secret_key,
  $db_name,
  $db_username,
  $db_password,
  $db_host,
  $db_port,
  $admin_email='root@localhost') inherits crams
{

  package { 'crams-api':
    ensure => installed,
  }

  file { '/etc/crams/settings.py':
    owner   => root,
    group   => root,
    mode    => '0600',
    content => template('crams/api/settings.erb'),
    require => Package['crams-api'],
  }
}
