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
      'command' => '/usr/bin/pkill -HUP -f puppet-server',
      'onlyif' => '/usr/bin/pgrep -f puppet-server',
      'refreshonly' => true,
    )
  }
end
