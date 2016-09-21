# Crams API server install and configuration
class crams::api (
  $crams_email,
  $admin_email,
  $rc_shib_url='https://accounts.rc.nectar.org.au/rcshibboleth',
  $ks_admin_user='crams',
  $ks_admin_pass,
  $ks_admin_project='service',
  $ks_auth_url,
  $nectar_approver_role='AllocationAdmin',
  $vicnode_approver_role='vicnode_approver',
  $crams_provisioner_role='crams_provisioner',
  $nectar_project_id_invalid_prefix_list=['pt-'],
  $crams_token_expiry_seconds=4 * 60 * 60,
  $allowed_hosts=[],
  $secret_key,
  $nectar_client_url = 'https://crams.rc.nectar.org.au',
  $nectar_client_view_request_path = '/#/allocations/view_request/',
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
