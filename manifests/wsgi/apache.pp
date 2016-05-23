# Apache WSGI setup

class crams::wsgi::apache {

  include ::apache::mod::wsgi

  apache::vhost {$::crams::host:
    serveradmin                 => $::crams::admin_email,
    port                        => $::crams::port,
    docroot                     => '/var/lib/www',
    fallbackresource            => '/usr/share/crams/static/severe-error.html',
    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'wsgi',
    wsgi_daemon_process_options => {
      processes    => '2',
      threads      => '15',
      display-name => '%{GROUP}',
    },

    wsgi_import_script          => '/usr/share/crams/wsgi/crams.wsgi',
    wsgi_import_script_options  => {
      process-group     => 'wsgi',
      application-group => '%{GLOBAL}',
    },

    wsgi_process_group          => 'wsgi',
    wsgi_script_aliases         => {
      '/' => '/usr/share/crams/wsgi/crams.wsgi'
    },

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
