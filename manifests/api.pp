# Crams API server install and configuration
  class crams::api (
    $host='localhost',
    $port=80,
    $external_port=80,
    $proto='http',
    $path='',
    $admin_email='root@localhost',
    $api_host,
    $api_port,
    $api_proto='http',
    $rcshibboleth_url,
    $auth_role,
    $auth_url,
  ) inherits crams {

  package {'crams-api':
    ensure => installed,
  }

  class { 'apache::mod::wsgi': }

  file {'/etc/crams/settings.py':
    owner   => root,
    group   => root,
    mode    => '0600',
    content => template('crams/api/settings.erb'),
    require => Package['crams-api'],
  }

  file {'/var/lib/www/error.html':
    owner   => root,
    group   => root,
    mode    => '0600',
    content => template('crams/api/error.erb'),
    require => Package['crams-api'],
  }

  apache::vhost {$host:
    serveradmin => $admin_email,
    port => $port,
    docroot => '/var/lib/www',
    fallbackresource => '/error.html',

    wsgi_application_group => '%{GLOBAL}',
    wsgi_daemon_process => 'wsgi',
    wsgi_daemon_process_options => {
      processes => '2',
      threads => '15',
      display-name =>' %{GROUP}',
    },

    wsgi_import_script => '/usr/share/crams/wsgi/crams.wsgi',
    wsgi_import_script_options => {
      process-group => 'wsgi',
      application-group => '%{GLOBAL}',
    },

    wsgi_process_group => 'wsgi',
    wsgi_script_aliases => {
      '/' => '/usr/share/crams/wsgi/crams.wsgi'
    },

    aliases => [
      {
        alias => '/media',
        path => '/usr/share/crams/media',
      },
      {
        alias => '/static',
        path => '/usr/share/crams/static',
      },
    ],
    directories => [
      {
        path => '/usr/share/crams/media',
        options => ['-Indexes']
      },
      {
        path => '/usr/share/crams/static',
        options => ['-Indexes']
      },
    ],
  }
 }
