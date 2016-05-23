class crams::cramsclient::nectar(
  $cramsapi_server,
  $cramsapi_auth_path,
  $crams_provision_api_path,
  $crams_provision_api_update_path,
  $os_auth_url,
  $os_tenant_name,
  $os_tenant_id,
  $os_user_name,
  $os_user_id,
  $os_password,
  $cron_hour,
  $cron_minute
) inherits crams{

  package { 'cramsclient-nectar':
    ensure => installed,
  }

  file { '/etc/cramsclient-nectar/settings.py':
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('cramsclient/nectar/setting.py.erb'),
    require => Package['cramsclient-nectar'],
  }

  cron { 'provision':
    command => 'python3 /usr/lib/python3/dist-packages/crams_provision/provision.py > /tmp/provision.log 2>&1',
    user    => root,
    hour    => $cron_hour,
    minute  => $cron_minute,
    require => Package['cramsclient-nectar'],
  }
}