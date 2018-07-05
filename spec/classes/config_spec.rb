require 'spec_helper'

describe 'puppetserver5::config' do
  let(:params) do
    {
      'init_configfile_path' => '/etc/sysconfig/puppetserver',
      'service_ca_cfg_path' => '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
    }
  end

  context 'only mandatory params passed - no ressources are manged' do
    it { is_expected.to compile }
    it { is_expected.to have_resource_count(0) }
  end

  context 'params set' do
    let(:params) do
      {
        'init_configfile_path' => '/etc/sysconfig/puppetserver',
        'init_vars' =>
          {
            'JAVA_ARGS' => '-Xms5g -Xmx4g -XX:UseG1GC -XX:ReservedCodeCacheSize=512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger',
            'JRUBY_JAR' => '/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar',
          },
        'service_ca_cfg_path' => '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
        'service_ca_disable' => true,
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file_line('/etc/sysconfig/puppetserver JAVA_ARGS').with(
        'ensure' => 'present',
        'path'   => '/etc/sysconfig/puppetserver',
        'line'   => 'JAVA_ARGS="-Xms5g -Xmx4g -XX:UseG1GC -XX:ReservedCodeCacheSize=512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger"',
      )
    }

    it {
      is_expected.to contain_file_line('/etc/sysconfig/puppetserver JRUBY_JAR').with(
        'ensure' => 'present',
        'path'   => '/etc/sysconfig/puppetserver',
        'line'   => 'JRUBY_JAR="/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar"',
      )
    }

    it { is_expected.to contain_file('/etc/puppetlabs/puppetserver/services.d/ca.cfg') }
  end

  context 'params set to ABSENT where possible' do
    let(:params) do
      {
        'init_configfile_path' => '/etc/sysconfig/puppetserver',
        'service_ca_cfg_path' => '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
        'init_vars' =>
          {
            'JAVA_ARGS' => 'ABSENT',
            'JRUBY_JAR' => 'ABSENT',
          },
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file_line('/etc/sysconfig/puppetserver JAVA_ARGS').with(
        'ensure'            => 'absent',
        'path'              => '/etc/sysconfig/puppetserver',
        'match_for_absence' => true,
      )
    }

    it {
      is_expected.to contain_file_line('/etc/sysconfig/puppetserver JRUBY_JAR').with(
        'ensure'            => 'absent',
        'path'              => '/etc/sysconfig/puppetserver',
        'match_for_absence' => true,
      )
    }

    it { is_expected.not_to contain_file('/etc/puppetlabs/puppetserver/services.d/ca.cfg') }
  end
end
