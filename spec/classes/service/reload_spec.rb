require 'spec_helper'

describe 'puppetserver5::service::reload' do
  let(:params) do
    {
      'service_manage' => true,
    }
  end

  it { is_expected.to compile }

  it {
    is_expected.to contain_exec('puppetserver5::service::reload').with(
      'command' => '/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver reload',
      'onlyif' => '/usr/bin/pgrep -f "puppet-server-release.jar.* -m puppetlabs.trapperkeeper.main"',
      'refreshonly' => true,
      'user' => 'puppet',
    )
  }
end
