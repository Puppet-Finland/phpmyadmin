# == Class: phpmyadmin::install
#
# This class installs the phpmyadmin daemon
#
class phpmyadmin::install inherits phpmyadmin::params {

    package { "${::phpmyadmin::params::package_name}":
        ensure => installed,
    }
}
