require 'spec_helper_acceptance'

describe 'puppetserver5 with some tuning' do
  let(:pp) do
    <<-EOS
      class { 'puppetserver5':
        init_java_args     => '-Xmx512m -Xms512m -XX:+UseG1GC -XX:ReservedCodeCacheSize=512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger',
        init_jruby_jar     => '/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar',
        # todo: can only be disabled when there are existing certs
        # service_ca_disable => true,
        auth_allow_header_cert_info => true,
        jruby_puppet_max_active_instances => 1,
        jruby_puppet_max_requests_per_instance => 100,
        webserver_host => '127.0.0.1',
        webserver_port => 18140,
        webserver_ssl_host => 'ABSENT',
        webserver_ssl_port => 'ABSENT',
        product_check_for_updates => false,
      }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe package('puppetserver') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/sysconfig/puppetserver') do
    its(:content) {  is_expected.to match(%r{^JAVA_ARGS=.*-Xmx512m}) }
    its(:content) {  is_expected.to match(%r{^JAVA_ARGS=.*-Xms512m}) }
    its(:content) {  is_expected.to match('JRUBY_JAR="/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar"') }
  end

  describe file('/etc/puppetlabs/puppetserver/conf.d/auth.conf') do
    its(:content) {  is_expected.to match(%r{^\s+allow-header-cert-info: true}) }
  end

  describe file('/etc/puppetlabs/puppetserver/conf.d/product.conf') do
    its(:content) {  is_expected.to match(%r{^\s+check-for-updates: false}) }
  end

  describe file('/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf') do
    its(:content) {  is_expected.to match(%r{^\s+max-requests-per-instance: 100}) }
    its(:content) {  is_expected.to match(%r{^\s+max-active-instances: 1}) }
  end

  describe file('/etc/puppetlabs/puppetserver/conf.d/webserver.conf') do
    its(:content) {  is_expected.to match(%r{^\s+host: "127.0.0.1"}) }
    its(:content) {  is_expected.to match(%r{^\s+port: 18140}) }
    its(:content) {  is_expected.not_to match(%r{^\s+ssl-host:}) }
    its(:content) {  is_expected.not_to match(%r{^\s+ssl-port:}) }
  end

  describe process('java') do
    its(:user) { is_expected.to match('puppet') }
    its(:args) { is_expected.to match('-Xmx512m -Xms512m') }
    its(:args) { is_expected.to match('G1GC') }
    its(:args) { is_expected.to match(':/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar:') }
  end

  describe service('pupetserver') do
    # serverspec wants to use systemctl - which does not work in docker')
    xit { is_expected.to be_running }
    xit { is_expected.to be_enabled }
  end
end
