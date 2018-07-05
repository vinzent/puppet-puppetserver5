require 'spec_helper'

describe 'puppetserver5::service' do
  let(:params) do
    {
      'service_ensure' => 'running',
      'service_name'   => 'puppetserver',
      'service_manage' => true,
      'service_enable' => true,
    }
  end

  it { is_expected.to compile }
  it { is_expected.to contain_service('puppetserver').with('ensure' => 'running', 'enable' => true) }
end
