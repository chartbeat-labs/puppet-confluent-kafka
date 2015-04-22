require 'spec_helper'

describe 'confluent_kafka' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "confluent_kafka class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('confluent_kafka::params') }
          it { is_expected.to contain_class('confluent_kafka::install').that_comes_before('confluent_kafka::config') }
          it { is_expected.to contain_class('confluent_kafka::config') }
          it { is_expected.to contain_class('confluent_kafka::service').that_subscribes_to('confluent_kafka::config') }

          it { is_expected.to contain_service('confluent_kafka') }
          it { is_expected.to contain_package('confluent_kafka').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'confluent_kafka class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('confluent_kafka') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
