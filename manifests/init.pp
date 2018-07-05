#
# Many of the settings allow you to specifiy the string ABSENT to remove the setting completly.
# If not passing a value (aka undef) then the module does not try to manage it at
# all.
#
# @summary Install and configure puppetserver 5
#
# @param package_manage Set to false if the package is installed by other means.
# @param package_name Use another package name to install
# @param service_manage Set to false if you don't want to manage the service with this module.
# @param service_name Define the name of the service.
# @param service_ensure Define the service ensure param when `running` is not what you want.
# @param service_enable Set to false if you don't wan't to enable the service at boot.
# @param init_configfile_path Path to the sysconfig puppetserver file
# @param init_java_args Manage the JAVA_ARGS env param in the sysconfig file
# @param init_jruby_jar Manage the JRUBY_JAR param in the sysconfig file
# @param service_ca_cfg_path Path to the ca.cfg service config file
# @param auth_conf_path Path to the auth.conf file
# @param service_ca_disable Set to true to disable the ca service
# @param puppetserver_conf_path Path to the puppetserver.conf file
# @param product_conf_path Path to the product.conf file
# @param webserver_conf_path Path to the webserver.conf file
# @param auth_allow_header_cert_info Set to true to allow passing cert info with HTTP headers
#   (beaware of security implications!)
# @param jruby_puppet_max_active_instances Configure max-active-instances tuning option
# @param jruby_puppet_max_requests_per_instance Configure max-request-per-instance tuning option
# @param webserver_host Configure HTTP host to bind to
# @param webserver_port Configure HTTP port to use
# @param webserver_ssl_host Configure HTTPS host to bind to
# @param webserver_ssl_port Configure HTTPS port to use
# @param product_check_for_updates Set to false to disable the update check (it's on by default)
#
# @see https://puppet.com/docs/puppetserver/5.3/external_ssl_termination.html
# @see https://puppet.com/docs/puppetserver/5.3/configuration.html
# @see https://github.com/puppetlabs/trapperkeeper-webserver-jetty9/blob/master/doc/jetty-config.md
# @see https://puppet.com/docs/puppetserver/5.3/restarting.html
# @see https://puppet.com/docs/puppetserver/5.3/tuning_guide.html
#
# @example Basic example - install and start
#   include puppetserver5
#
# @example Complex example
#  class { 'puppetserver5':
#    init_java_args     => '-Xmx8g -Xms8g -XX:+UseG1GC -XX:ReservedCodeCacheSize=512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger',
#    init_jruby_jar                         => '/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar',
#    service_ca_disable                     => true,
#    auth_allow_header_cert_info            => true,
#    jruby_puppet_max_active_instances      => 6,
#    jruby_puppet_max_requests_per_instance => 10000,
#    webserver_host                         => '127.0.0.1',
#    webserver_port                         => 18140,
#    webserver_ssl_host                     => 'ABSENT',
#    webserver_ssl_port                     => 'ABSENT',
#    product_check_for_updates              => false,
#  }
class puppetserver5(
  Boolean $package_manage = true,
  String $package_name = 'puppetserver',
  Boolean $service_manage = true,
  Stdlib::Ensure::Service $service_ensure = 'running',
  Boolean $service_enable = true,
  String $service_name = 'puppetserver',
  Stdlib::AbsolutePath $init_configfile_path = '/etc/sysconfig/puppetserver',
  Optional[String] $init_java_args = undef,
  Puppetserver5::AbsolutePathOrABSENT $init_jruby_jar = undef,
  Stdlib::AbsolutePath $service_ca_cfg_path = '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
  Stdlib::AbsolutePath $auth_conf_path = '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
  Optional[Boolean] $service_ca_disable = undef,
  Puppetserver5::BooleanOrABSENT $auth_allow_header_cert_info = undef,
  Stdlib::AbsolutePath $product_conf_path = '/etc/puppetlabs/puppetserver/conf.d/product.conf',
  Puppetserver5::BooleanOrABSENT $product_check_for_updates = undef,
  Stdlib::AbsolutePath $puppetserver_conf_path = '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
  Puppetserver5::IntegerOrABSENT $jruby_puppet_max_active_instances = undef,
  Puppetserver5::IntegerOrABSENT $jruby_puppet_max_requests_per_instance = undef,
  Stdlib::AbsolutePath $webserver_conf_path = '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
  Puppetserver5::HostOrABSENT $webserver_host = undef,
  Puppetserver5::PortOrABSENT $webserver_port = undef,
  Puppetserver5::HostOrABSENT $webserver_ssl_host = undef,
  Puppetserver5::PortOrABSENT $webserver_ssl_port = undef,
) {

  class { 'puppetserver5::install':
    package_manage => $package_manage,
    package_name   => $package_name,
  }

  class { 'puppetserver5::config':
    init_configfile_path => $init_configfile_path,
    init_vars            => {
      'JAVA_ARGS' => $init_java_args,
      'JRUBY_JAR' => $init_jruby_jar,
    },
    service_ca_cfg_path  => $service_ca_cfg_path,
    service_ca_disable   => $service_ca_disable,
  }

  class { 'puppetserver5::config::reloadonly':
    auth_conf_path             => $auth_conf_path,
    product_conf_path          => $product_conf_path,
    puppetserver_conf_path     => $puppetserver_conf_path,
    webserver_conf_path        => $webserver_conf_path,
    auth_conf_settings         => {
      'authorization.allow-header-cert-info' => $auth_allow_header_cert_info,
    },
    product_conf_settings      => {
      'product.check-for-updates' => $product_check_for_updates,
    },
    puppetserver_conf_settings => {
      'jruby-puppet.max-active-instances'      => $jruby_puppet_max_active_instances,
      'jruby-puppet.max-requests-per-instance' => $jruby_puppet_max_requests_per_instance,
    },
    webserver_conf_settings    => {
      'webserver.host'     => $webserver_host,
      'webserver.port'     => $webserver_port,
      'webserver.ssl-host' => $webserver_ssl_host,
      'webserver.ssl-port' => $webserver_ssl_port,
    },
  }

  class { 'puppetserver5::service':
    service_manage => $service_manage,
    service_name   => $service_name,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }

  class { 'puppetserver5::service::reload':
    service_manage => $service_manage,
  }

  contain puppetserver5::install
  contain puppetserver5::config
  contain puppetserver5::config::reloadonly
  contain puppetserver5::service::reload
  contain puppetserver5::service

  Class['puppetserver5::install']
  -> Class['puppetserver5::config']
  -> Class['puppetserver5::config::reloadonly']
  -> Class['puppetserver5::service::reload']
  -> Class['puppetserver5::service']

  Class['puppetserver5::config::reloadonly']
  ~> Class['puppetserver5::service::reload']

  Class['puppetserver5::config']
  ~> Class['puppetserver5::service']
}
