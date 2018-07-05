#
# @summary Private class to manage the puppetserver service
#
# @example
#   include puppetserver5::service
#
# @private
#
class puppetserver5::service(
  String $service_name,
  Boolean $service_manage,
  Stdlib::Ensure::Service $service_ensure,
  Boolean $service_enable,
) {
  if $service_manage {
    service { $service_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasrestart => true,
    }
  }
}
