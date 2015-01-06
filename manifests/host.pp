#
# == Class: phpmyadmin::host
#
# Add this host to the phpmyadmin server's server list and grant the 'pma' user 
# access to all databases on this host.
#
# == Parameters
#
# [*ensure*]
#   Status of the phpmyadmin server configuration fragment. Valid values 
#   'present' (default) and 'absent'.
# [*allow_address_ipv4*]
#   IPv4 address from which to allow access to the MySQL server on this host. Defaults to '127.0.0.1'.
# [*allow_address_ipv6*]
#   IPv6 address from which to allow access to the MySQL server on this host. Defaults to '::1'.
# [*privileges*]
#   A string of MySQL privileges to grant the 'pma' user connecting from the 
#   given ipv4 and ipv6 addresses. Typically this needs to be 'ALL PRIVILEGES' 
#   for phpmyadmin to be of much use, but the default value is 'USAGE' to err on 
#   the safe side.
# [*password*]
#   Password for the 'pma' user.
#
class phpmyadmin::host
(
    $ensure='present',
    $allow_address_ipv4='127.0.0.1',
    $allow_address_ipv6='::1',
    $privileges='USAGE',
    $password

) inherits phpmyadmin::params
{

    include apache2::params

    # Grant access to the MySQL instance
    mysql::grant { "phpmyadmin-pma-${allow_address_ipv4}":
        user => 'pma',
        password => $password,
        host => "${allow_address_ipv4}",
        privileges => $privileges,
    }

    mysql::grant { "phpmyadmin-pma-${allow_address_ipv6}":
        user => 'pma',
        password => $password,
        host => "${allow_address_ipv6}",
        privileges => $privileges,
    }

    # Export the server definition - it will be collected by the phpmyadmin 
    # server.
    @@file { "phpmyadmin-${::fqdn}.php":
        ensure => $ensure,
        name => "${::phpmyadmin::params::conf_d_dir}/${::fqdn}.php",
        content => template('phpmyadmin/host.php.erb'),
        mode => 640,
        owner => root,
        group => "${::apache2::params::www_group}",
        tag => 'phpmyadmin-host',
        require => Class['phpmyadmin::install'],
    }
}
