require 'spec_helper_acceptance'

describe 'puppetserver5 class' do
  let(:pp) do
    <<-EOS
      class { 'puppetserver5':
        # the 2GB memory is a bit too much with travis & docker
        init_java_args     => '-Xmx512m -Xms512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger',
      }

    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe package('puppetserver') do
    it { is_expected.to be_installed }
  end

  describe process('java') do
    its(:user) { is_expected.to match('puppet') }
    its(:args) { is_expected.to match('-Xmx512m -Xms512m') }
  end

  describe service('pupetserver') do
    # serverspec wants to use systemctl on docker - which does not work
    xit { is_expected.to be_running }
    xit { is_expected.to be_enabled }
  end
end
