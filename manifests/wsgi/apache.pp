# Apache WSGI setup

class crams::wsgi::apache {

  include ::apache::mod::wsg
  
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
        path  => '/usr/share/crams/media',
      },
      {
        alias => '/static',
        path  => '/usr/share/crams/static',
      },
    ],
    directories                 => [
      {
        path    => '/usr/share/crams/media',
        options => ['-Indexes']
      },
      {
        path    => '/usr/share/crams/static',
        options => ['-Indexes']
      },
    ],
  }
}
