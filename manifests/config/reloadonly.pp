#
# @summary Private class that manages settings that only
#   require a reload of the service but not a full restart.
#
# @see https://puppet.com/docs/puppetserver/5.3/restarting.html
#
class puppetserver5::config::reloadonly(
  Stdlib::AbsolutePath $auth_conf_path,
  Stdlib::AbsolutePath $webserver_conf_path,
  Stdlib::AbsolutePath $puppetserver_conf_path,
  Stdlib::AbsolutePath $product_conf_path,
  Optional[Hash[Pattern[/\A[a-z\-\.]+\Z/],Optional[Any]]] $product_conf_settings = undef,
  Optional[Hash[Pattern[/\A[a-z\-\.]+\Z/],Optional[Any]]] $webserver_conf_settings = undef,
  Optional[Hash[Pattern[/\A[a-z\-\.]+\Z/],Optional[Any]]] $puppetserver_conf_settings = undef,
  Optional[Hash[Pattern[/\A[a-z\-\.]+\Z/],Optional[Any]]] $auth_conf_settings = undef,
) {

  if $product_conf_settings !~ Undef {
    $product_conf_settings.each |$item| {
      $setting = $item[0]
      $value = $item[1]

      if $value !~ Undef {
        hocon_setting { "puppetserver ${setting}":
          ensure  => puppetserver5::to_ensure($value),
          path    => $product_conf_path,
          setting => $setting,
          value   => $value,
        }
      }
    }
  }

  if $webserver_conf_settings !~ Undef {
    $webserver_conf_settings.each |$item| {
      $setting = $item[0]
      $value = $item[1]

      if $value !~ Undef {
        hocon_setting { "puppetserver ${setting}":
          ensure  => puppetserver5::to_ensure($value),
          path    => $webserver_conf_path,
          setting => $setting,
          value   => $value,
        }
      }
    }
  }

  if $puppetserver_conf_settings !~ Undef {
    $puppetserver_conf_settings.each |$item| {
      $setting = $item[0]
      $value = $item[1]

      if $value !~ Undef {
        hocon_setting { "puppetserver ${setting}":
          ensure  => puppetserver5::to_ensure($value),
          path    => $puppetserver_conf_path,
          setting => $setting,
          value   => $value,
        }
      }
    }
  }

  if $auth_conf_settings !~ Undef {
    $auth_conf_settings.each |$item| {
      $setting = $item[0]
      $value = $item[1]

      if $value !~ Undef {
        hocon_setting { "puppetserver ${setting}":
          ensure  => puppetserver5::to_ensure($value),
          path    => $auth_conf_path,
          setting => $setting,
          value   => $value,
        }
      }
    }
  }
}
