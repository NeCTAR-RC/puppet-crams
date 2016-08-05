class crams::provisioner::nectar(
  $cramsapi_server,
  $cramsapi_auth_path='json_token_auth',
  $crams_provision_api_path='api/v1/provision_project/list',
  $crams_provision_api_update_path='api/v1/provision_project/update',
  $provision_log_dir = '/var/log/cramsclient-nectar',
  $os_auth_url,
  $os_project_name,
  $os_username,
  $os_password,
  $crams_user='crams',
  $crams_group='crams',
  $cron_hour='*',
  $cron_minute='*/30'
) inherits crams{

  package { 'cramsclient-nectar':
    ensure => installed,
  }

  user { $crams_user:
    ensure => 'present',
  }

  group { $crams_group:
    ensure => 'present',
  }

  file { $provision_log_dir:
    ensure => 'directory',
    owner  => $crams_user,
    group  => $crams_group,
    mode   => '0750',
  }

  file { '/etc/cramsclient-nectar/settings.py':
    owner   => $crams_user,
    group   => $crams_group,
    mode    => '0644',
    content => template('crams/provisioner/nectar/setting.py.erb'),
    require => Package['cramsclient-nectar'],
  }

  cron { 'crams-provision-accounts':
    command => "/usr/bin/crams-provision-nectar > ${$provision_log_dir}/provision.log 2>&1",
    user    => $crams_user,
    hour    => $cron_hour,
    minute  => $cron_minute,
    require => Package['cramsclient-nectar'],
  }

}
