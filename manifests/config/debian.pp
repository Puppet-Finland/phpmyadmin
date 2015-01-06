#
# == Class: phpmyadmin::config::debian
#
# Debian-specific parts of phpmyadmin setup
#
class phpmyadmin::config::debian
(
    $db_pass

) inherits phpmyadmin::params
{

    include apache2::params

    file { 'phpmyadmin-config-db.php':
        name => "${::phpmyadmin::params::config_dir}/config-db.php",
        ensure => present,
        content => template('phpmyadmin/config-db.php.erb'),
        owner => root,
        group => "${::apache2::params::www_group}",
        mode => 640,
        require => Class['phpmyadmin::install'],
    }
}
