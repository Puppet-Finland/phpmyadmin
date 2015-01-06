#
# == Class: phpmyadmin::config
#
# Configure phpmyadmin
#
class phpmyadmin::config
(
    $db_pass

) inherits phpmyadmin::params
{

    include apache2::params

    file { 'phpmyadmin-config.inc.php':
        name => "${::phpmyadmin::params::config_dir}/config.inc.php",
        ensure => present,
        content => template('phpmyadmin/config.inc.php.erb'),
        owner => root,
        group => "${::apache2::params::www_group}",
        mode => 640,
        require => Class['phpmyadmin::install'],
    }

    # Import server entries from hosts that include the phpmyadmin::host class
    File <<| tag == 'phpmyadmin-host' |>>

    # Prepare MySQL for phpmyadmin
    class { 'phpmyadmin::config::mysql':
        db_pass => $db_pass,
    }

    if $::osfamily == 'Debian' {
        class { 'phpmyadmin::config::debian':
            db_pass => $db_pass,
        }
    }
}
