#
# @summary Private class that manages settings that require a restart of the daemon
#
# @example
#   include puppetserver5::config
class puppetserver5::config(
  Stdlib::AbsolutePath $init_configfile_path,
  Stdlib::AbsolutePath $service_ca_cfg_path,
  Optional[Hash[Pattern[/\A[A-Z_]+\Z/],Optional[String[1]]]] $init_vars = undef,
  Optional[Boolean] $service_ca_disable = undef,
) {

  if $init_vars !~ Undef {
    $init_vars.each |$item| {
      $var = $item[0]
      $value = $item[1]

      if $value !~ Undef {
        file_line { "${init_configfile_path} ${var}":
          ensure            => puppetserver5::to_ensure($value),
          path              => $init_configfile_path,
          line              => "${var}=\"${$value}\"",
          match             => "^${var}=.*\$",
          match_for_absence => true,
        }
      }
    }
  }

  if $service_ca_disable !~ Undef {
    $ca_service_content = $service_ca_disable ? {
      true => 'puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
      default => 'puppetlabs.services.ca.certificate-authority-service/certificate-authority-service',
    }

    file { $service_ca_cfg_path:
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "# Managed by puppet\n${ca_service_content}\n",
    }
  }
}
