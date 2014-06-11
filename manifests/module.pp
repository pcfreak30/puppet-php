# Define: php::module
#
# Manage optional PHP modules which are separately packaged.
# See also php::module:ini for optional configuration.
#
# Sample Usage :
#  php::module { [ 'ldap', 'mcrypt', 'xml' ]: }
#  php::module { 'odbc': ensure => absent }
#  php::module { 'pecl-apc': }
#
define php::module (
  $ensure = installed,
  $params_class = '::php::params',
) {

  include $params_class
  $class = "${params_class}::php_package_name"
  # Manage the incorrect named php-apc package under Debians
  if ($title == 'apc') {
	$class = "${params_class}::php_apc_package_name"
    $package = getvar($class)
  } else {
    # Hack to get pkg prefixes to work, i.e. php56-mcrypt title
    $package = $title ? {
      /^php/  => $title,
      default => inline_template("<%= scope.lookupvar(scope.lookupvar('class')) %>-<%= scope.lookupvar('title')  %>"),
    }
  }

  package { $package:
    ensure => $ensure,
  }
}


