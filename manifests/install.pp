#
# @summary Private class to install the puppetserver package
#
# @example
#   include puppetserver5::install
class puppetserver5::install(
  String $package_name,
  Boolean $package_manage,
) {
  if $package_manage {
    package { $package_name:
      ensure => 'installed',
    }
  }
}
