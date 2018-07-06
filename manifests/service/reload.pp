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
      command     => '/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver reload',
      onlyif      => '/usr/bin/pgrep -f "puppet-server-release.jar.* -m puppetlabs.trapperkeeper.main"',
      refreshonly => true,
      user        => 'puppet',
    }
  }
}
