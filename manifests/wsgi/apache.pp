# Apache WSGI setup
class crams::wsgi::apache(
  $servername         = $::fqdn,
  $bind_host          = undef,
  $path               = '/',
  $service_name       = 'crams_wsgi',
  $user               = 'crams',
  $group              = 'crams',
  $ssl                = true,
  $workers            = 1,
  $ssl_cert           = undef,
  $ssl_key            = undef,
  $ssl_chain          = undef,
  $ssl_ca             = undef,
  $ssl_certs_dir      = undef,
  $threads            = $::processorcount,
  $priority           = '10',
  $wsgi_script_dir    = '/var/www/crams',
  $wsgi_script_file   = 'app.wsgi',
  $wsgi_script_source = '/usr/share/crams/wsgi/crams.wsgi',
) {

  include ::apache
  include ::apache::mod::wsgi
  if $ssl {
    include ::apache::mod::ssl
    $port = 443
  } else {
    $port = 80
  }
  # Ensure there's no trailing '/' except if this is also the only character
  $path_real = regsubst($path, '(^/.*)/$', '\1')

  if !defined(File[$wsgi_script_dir]) {
    file { $wsgi_script_dir:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      require => Package['httpd'],
    }
  }

  file { $service_name:
    ensure  => file,
    path    => "${wsgi_script_dir}/${wsgi_script_file}",
    source  => $wsgi_script_source,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    require => File[$wsgi_script_dir],
  }

  $wsgi_daemon_process_options = {
    user      => $user,
    group     => $group,
    processes => $workers,
    threads   => $threads,
  }
  $wsgi_script_aliases = hash([$path_real,"${wsgi_script_dir}/${wsgi_script_file}"])


  ::apache::vhost { $service_name:
    ensure                      => 'present',
    servername                  => $servername,
    ip                          => $bind_host,
    port                        => $port,
    docroot                     => $wsgi_script_dir,
    docroot_owner               => $user,
    docroot_group               => $group,
    priority                    => $priority,
    ssl                         => $ssl,
    ssl_cert                    => $ssl_cert,
    ssl_key                     => $ssl_key,
    ssl_chain                   => $ssl_chain,
    ssl_ca                      => $ssl_ca,
    ssl_certs_dir               => $ssl_certs_dir,
    wsgi_daemon_process         => $user,
    wsgi_daemon_process_options => $wsgi_daemon_process_options,
    wsgi_process_group          => $group,
    wsgi_script_aliases         => $wsgi_script_aliases,
    wsgi_application_group      => '%{GLOBAL}',
    require                     => File[$service_name],
    fallbackresource            => '/usr/share/crams/static/severe-error.html',
    serveradmin                 => $::crams::api::admin_email,
    aliases                     => [
      {
        alias => '/media',
        path  => '/var/www/crams/media',
      },
      {
        alias => '/static',
        path  => '/var/www/crams/static',
      },
    ],
    directories                 => [
      {
        path    => '/var/www/crams/media',
        options => ['-Indexes']
      },
      {
        path    => '/var/www/crams/static',
        options => ['-Indexes']
      },
    ],
  }
}
