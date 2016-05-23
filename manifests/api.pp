# Crams API server install and configuration
class crams::api (
  $crams_email_address,
  $admin_email,
  $ks_admin_user,
  $ks_admin_pass,
  $ks_admin_tenant,
  $ks_auth_url,
  $allowed_hosts=[],
  $secret_key,
  $db_name='crams',
  $db_username='crams',
  $db_password,
  $db_host='localhost',
  $db_port='') inherits crams
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

  if defined(Service[$::apache::service::service_name]) {
    File {
      notify => Service[$::apache::service::service_name]
    }
  }
}
