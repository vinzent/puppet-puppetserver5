
# puppetserver5

Install & configure puppetserver 5.

This module really only manages what puppetserver package provides. All
other things should be done at the profile level (if using the
roles/profiles pattern).

## Setup

### Setup Requirements

What this module doesn't do and you need to ensure yourself before including it:

* It doesn't configure the puppet package repository
* It doesn't manage puppet.conf settings

### Beginning with puppetserver5

Most of the params are optional. If you don't pass a value, then the module
won't try to manage the setting at all.

If you pass the string 'ABSENT' to settings params then the setting will
be removed.

Simple example:

```puppet
include puppetserver5

```

Complex example:

```puppet
class { 'puppetserver5':
  init_java_args     => '-Xmx8g -Xms8g -XX:+UseG1GC -XX:ReservedCodeCacheSize=512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger',
  init_jruby_jar                         => '/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar',
  service_ca_disable                     => true,
  auth_allow_header_cert_info            => true,
  jruby_puppet_max_active_instances      => 6,
  jruby_puppet_max_requests_per_instance => 10000,
  webserver_host                         => '127.0.0.1',
  webserver_port                         => 18140,
  webserver_ssl_host                     => 'ABSENT',
  webserver_ssl_port                     => 'ABSENT',
  product_check_for_updates              => false,
}
```

If you wan't to manage auth.conf rules with [puppetlabs/puppet_authorization](https://forge.puppet.com/puppetlabs/puppet_authorization)
you'll need to ensure it only gets manage after the package is installed and that it sends
a notify to the service reload class.

```puppet
Class['puppetserver5::install']

-> puppet_authorization { 'xyz': ... }

~> Class['puppetserver5::service::reload']
```

See [REFERENCE.md](REFERENCE.md) for the puppet strings generated documentation.
