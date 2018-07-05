require 'spec_helper'

describe 'puppetserver5' do
  it { is_expected.to compile }

  context 'Many params set' do
    let(:params) do
      {
        'init_java_args' => '-Xms2g -Xmx2g -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger',
        'init_jruby_jar' => '/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar',
        'service_ca_disable' => false,
        'auth_allow_header_cert_info' => true,
        'jruby_puppet_max_active_instances' => 5,
        'jruby_puppet_max_requests_per_instance' => 5,
        'webserver_host' => 'puppet.my.domain',
        'webserver_port' => 18_140,
        'webserver_ssl_host' => 'ABSENT',
        'webserver_ssl_port' => 'ABSENT',
        'product_check_for_updates' => false,
      }
    end

    it { is_expected.to compile }
  end
end
