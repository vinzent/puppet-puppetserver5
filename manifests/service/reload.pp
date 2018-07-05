#
# @summary Private class which triggers a service reload
#   when notified.
#
# @example
#   include puppetserver5::service::reload
class puppetserver5::service::reload(
  Boolean $service_manage,
) {
  if $service_manage {
    exec { 'puppetserver5::service::reload':
      command     => '/usr/bin/pkill -HUP -f puppet-server',
      onlyif      => '/usr/bin/pgrep -f puppet-server',
      refreshonly => true,
    }
  }
}
