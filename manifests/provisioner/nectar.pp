class crams::provisioner::nectar(
  $cramsapi_server,
  $cramsapi_auth_path='json_token_auth',
  $crams_provision_api_path='api/v1/provision_project/list',
  $crams_provision_api_update_path='api/v1/provision_project/update',
  $provision_log_dir = '/var/log',
  $os_auth_url,
  $os_project_name,
  $os_username,
  $os_password,
  $cron_hour='*',
  $cron_minute='*/30'
) inherits crams{

  package { 'cramsclient-nectar':
    ensure => installed,
  }

  file { '/etc/cramsclient-nectar/settings.py':
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('crams/provisioner/nectar/setting.py.erb'),
    require => Package['cramsclient-nectar'],
  }

  cron { 'crams-provision-accounts':
    command => '/usr/bin/crams-provision-nectar > /var/log/cramsclient-nectar/provision.log 2>&1',
    user    => root,
    hour    => $cron_hour,
    minute  => $cron_minute,
    require => Package['cramsclient-nectar'],
  }

}
