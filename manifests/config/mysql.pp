#
# == Class: phpmyadmin::config::mysql
#
# Prepare mysql for phpmyadmin
#
class phpmyadmin::config::mysql
(
    $db_pass

) inherits phpmyadmin::params
{

    # Load the phpmyadmin database schema
    exec { 'phpmyadmin-load-create_tables.sql':
        command => "zcat ${::phpmyadmin::params::examples_dir}/${::phpmyadmin::params::create_tables_sql}|mysql --defaults-extra-file=/root/.my.cnf",
        path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
        user => root,
        unless => "mysql --defaults-extra-file=/root/.my.cnf -e \"SHOW DATABASES\"|grep phpmyadmin",
        require => Class['phpmyadmin::install'],
    }

    # Grant access to the 'pma' user
    mysql::grant { 'phpmyadmin-pma-localhost':
        user => 'pma',
        password => $db_pass,
        host => 'localhost',
        database => 'phpmyadmin',
        privileges => 'ALL PRIVILEGES',
    }
}
