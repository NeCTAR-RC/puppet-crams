class crams::frontend(
  $cramsapi_server,
  $servername          = $::fqdn,
  $bind_host           = undef,
  $ssl                 = true,
  $ssl_cert            = $::ssl_cert_path,
  $ssl_key             = $::ssl_key_path,
  $ssl_chain           = undef,
  $ssl_ca              = $::ssl_cacert_path,
  $ssl_certs_dir       = undef,
  $crams_frontend_root = '/var/www/app'

) inherits crams{

  include ::apache

  if $ssl {
    $port = 443
    include ::apache::mod::ssl
  } else {
    $port = 80
  }

  package { 'crams-rc-frontend':
    ensure => installed,
  }

  file { '/var/www/app':
    ensure  => 'link',
    target  => '/usr/share/crams-rc-frontend/app',
    require => Package['crams-rc-frontend'],
  }

  file { '/etc/crams-rc-frontend/crams.config.js':
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('crams/frontend/crams.config.js.erb'),
    require => Package['crams-rc-frontend'],
  }

  file { '/usr/share/crams-rc-frontend/app/js/crams.config.js':
    ensure  => 'link',
    target  => '/etc/crams-rc-frontend/crams.config.js',
    force   => true,
    require => Package['crams-rc-frontend'],
  }

  ::apache::vhost { 'crams-rc-frontend':
    ensure        => 'present',
    servername    => $servername,
    port          => $port,
    ip            => $bind_host,
    docroot       => $crams_frontend_root,
    ssl           => $ssl,
    ssl_cert      => $ssl_cert,
    ssl_key       => $ssl_key,
    ssl_chain     => $ssl_chain,
    ssl_certs_dir => $ssl_certs_dir,
  }
}
