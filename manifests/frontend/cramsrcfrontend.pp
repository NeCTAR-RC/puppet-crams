class crams::frontend::cramsrcfrontend(
  $cramsapi_server,
  $servername          = $::fqdn,
  $port                = 443,
  $bind_host           = undef,
  $ssl                 = true,
  $ssl_cert            = undef,
  $ssl_key             = undef,
  $ssl_chain           = undef,
  $ssl_ca              = undef,
  $ssl_certs_dir       = undef,
  $crams_frontend_root = '/var/www/app'

) inherits crams{

  include ::apache

  if $ssl {
    include ::apache::mod::ssl
  }

  package { 'crams-rc-frontend':
    ensure => installed,
  }

  file { '/var/www/app':
    ensure  => 'link',
    target  => '/usr/share/crams-rc-frontend/app',
    require => Package['crams-rc-frontend'],
  }

  file { '/usr/share/crams-rc-frontend/app/js/crams.config.js':
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('frontend/crams.config.js.erb'),
      require => Package['crams-rc-frontend'],
   }

  ::apache::vhost { $servername:
    ensure         => 'present',
    servername     => $servername,
    port           => $port,
    ip             => $bind_host,
    docroot        => $crams_frontend_root,
    ssl            => $ssl,
    ssl_cert       => $ssl_cert,
    ssl_key        => $ssl_key,
    ssl_chain      => $ssl_chain,
    ssl_certs_dir  => $ssl_certs_dir,
  }
}