#
# == Class: phpmyadmin::params
#
# Defines some variables based on the operating system
#
class phpmyadmin::params {

    case $::osfamily {
        'Debian': {
            $package_name = 'phpmyadmin'
            $config_dir = '/etc/phpmyadmin'
            $conf_d_dir = "${config_dir}/conf.d"
            $create_tables_sql = '/usr/share/doc/phpmyadmin/examples/create_tables.sql.gz'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
