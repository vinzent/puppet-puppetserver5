require 'spec_helper_acceptance'

describe 'puppetserver5 ca service' do
  context 'ca service enabled' do
    let(:pp) do
      <<-EOS
        class { 'puppetserver5':
          service_ca_disable => false,
        }
      EOS
    end

    it_behaves_like 'a idempotent resource'

    describe file('/etc/puppetlabs/puppetserver/services.d/ca.cfg') do
      its(:content) { is_expected.not_to match(%r{^puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service$}) }
      its(:content) { is_expected.to match(%r{^puppetlabs.services.ca.certificate-authority-service/certificate-authority-service$}) }
      context 'the filesystem-watch-service is still present' do
        its(:content) { is_expected.to match(%r{^puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service/filesystem-watch-service$}) }
      end
    end
  end

  context 'ca service disabled' do
    let(:pp) do
      <<-EOS
        class { 'puppetserver5':
          service_ca_disable => true,
        }
      EOS
    end

    it_behaves_like 'a idempotent resource'

    describe file('/etc/puppetlabs/puppetserver/services.d/ca.cfg') do
      its(:content) { is_expected.to match(%r{^puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service$}) }
      its(:content) { is_expected.not_to match(%r{^puppetlabs.services.ca.certificate-authority-service/certificate-authority-service$}) }
      context 'the filesystem-watch-service is still present' do
        its(:content) { is_expected.to match(%r{^puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service/filesystem-watch-service$}) }
      end
    end
  end
end
