require 'spec_helper'

describe 'puppetserver5::config::reloadonly' do
  let(:params) do
    {
      'product_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/product.conf',
      'auth_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
      'webserver_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
      'puppetserver_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
    }
  end

  context 'no params passed - no managed resources' do
    it { is_expected.to compile }
    it { is_expected.to have_resource_count(0) }
  end

  context 'params passed' do
    let(:params) do
      {
        'product_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/product.conf',
        'auth_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
        'webserver_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'puppetserver_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
        'product_conf_settings' => {
          'product.check-for-updates' => false,
        },
        'auth_conf_settings' => {
          'authorization.allow-header-cert-info' => true,
        },
        'puppetserver_conf_settings' => {
          'jruby-puppet.max-active-instances' => 4,
          'jruby-puppet.max-requests-per-instance' => 100,
        },
        'webserver_conf_settings' => {
          'webserver.host' => 'localhost',
          'webserver.port' => 18_140,
          'webserver.ssl-host' => 'my.fq.dn',
          'webserver.ssl-port' => 8_140,
        },
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_hocon_setting('puppetserver authorization.allow-header-cert-info').with(
        'ensure'  => 'present',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
        'setting' => 'authorization.allow-header-cert-info',
        'value'   => true,
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver jruby-puppet.max-active-instances').with(
        'ensure'  => 'present',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
        'setting' => 'jruby-puppet.max-active-instances',
        'value'   => 4,
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver jruby-puppet.max-requests-per-instance').with(
        'ensure'  => 'present',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
        'setting' => 'jruby-puppet.max-requests-per-instance',
        'value'   => 100,
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver product.check-for-updates').with(
        'ensure'  => 'present',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/product.conf',
        'setting' => 'product.check-for-updates',
        'value'   => false,
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver webserver.host').with(
        'ensure'  => 'present',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'setting' => 'webserver.host',
        'value'   => 'localhost',
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver webserver.port').with(
        'ensure'  => 'present',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'setting' => 'webserver.port',
        'value'   => 18_140,
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver webserver.ssl-host').with(
        'ensure'  => 'present',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'setting' => 'webserver.ssl-host',
        'value'   => 'my.fq.dn',
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver webserver.ssl-port').with(
        'ensure'  => 'present',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'setting' => 'webserver.ssl-port',
        'value'   => 8_140,
      )
    }
  end

  context 'params passed ans set to ABSENT where possible' do
    let(:params) do
      {
        'product_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/product.conf',
        'auth_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
        'webserver_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'puppetserver_conf_path' => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
        'product_conf_settings' => {
          'product.check-for-updates' => 'ABSENT',
        },
        'auth_conf_settings' => {
          'authorization.allow-header-cert-info' => 'ABSENT',
        },
        'puppetserver_conf_settings' => {
          'jruby-puppet.max-active-instances' => 'ABSENT',
          'jruby-puppet.max-requests-per-instance' => 'ABSENT',
        },
        'webserver_conf_settings' => {
          'webserver.host' => 'ABSENT',
          'webserver.port' => 'ABSENT',
          'webserver.ssl-host' => 'ABSENT',
          'webserver.ssl-port' => 'ABSENT',
        },
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_hocon_setting('puppetserver authorization.allow-header-cert-info').with(
        'ensure'  => 'absent',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
        'setting' => 'authorization.allow-header-cert-info',
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver jruby-puppet.max-active-instances').with(
        'ensure'  => 'absent',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
        'setting' => 'jruby-puppet.max-active-instances',
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver jruby-puppet.max-requests-per-instance').with(
        'ensure'  => 'absent',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
        'setting' => 'jruby-puppet.max-requests-per-instance',
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver webserver.host').with(
        'ensure'  => 'absent',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'setting' => 'webserver.host',
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver webserver.port').with(
        'ensure'  => 'absent',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'setting' => 'webserver.port',
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver webserver.ssl-host').with(
        'ensure'  => 'absent',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'setting' => 'webserver.ssl-host',
      )
    }

    it {
      is_expected.to contain_hocon_setting('puppetserver webserver.ssl-port').with(
        'ensure'  => 'absent',
        'path'    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
        'setting' => 'webserver.ssl-port',
      )
    }
  end
end
