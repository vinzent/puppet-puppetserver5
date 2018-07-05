require 'spec_helper'

describe 'puppetserver5::install' do
  let(:params) do
    {
      'package_name' => 'puppetserver',
      'package_manage' => true,
    }
  end

  it { is_expected.to compile }
  it { is_expected.to contain_package('puppetserver') }
end
