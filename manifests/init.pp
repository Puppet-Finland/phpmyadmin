# == Class: phpmyadmin
#
# This class install and configures phpmyadmin
#
# == Parameters
#
# [*db_pass*]
#   The password for the phpmyadmin's mysql database. The username is set to 
#   'pma' and the database name is 'phpmyadmin'.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class phpmyadmin
(
    $db_pass

) inherits phpmyadmin::params
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_phpmyadmin', 'true') != 'false' {

    include phpmyadmin::install

    class { 'phpmyadmin::config':
        db_pass => $db_pass,
    }
}
}
