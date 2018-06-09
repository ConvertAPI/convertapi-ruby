RSpec.describe ConvertApi do
  it 'has configuration defaults' do
    expect(described_class.config.api_base_uri).not_to be_nil
    expect(described_class.config.connect_timeout).not_to be_nil
    expect(described_class.config.conversion_timeout).not_to be_nil
  end

  describe '.configure' do
    let(:api_secret) { 'test_secret' }
    let(:conversion_timeout) { 20 }

    it 'configures' do
      described_class.configure do |config|
        config.api_secret = api_secret
        config.conversion_timeout = conversion_timeout
      end

      expect(described_class.config.api_secret).to eq(api_secret)
      expect(described_class.config.conversion_timeout).to eq(conversion_timeout)
    end
  end

  describe '.client' do
    subject { described_class.client }

    it { is_expected.to be_instance_of(ConvertApi::Client) }
  end

  describe '.convert' do
    subject { described_class.convert(from_format, to_format, resource, params) }

    let(:from_format) { 'txt' }
    let(:to_format) { 'pdf' }
    let(:resource) { 'LICENSE.txt' }
    let(:params) { {} }

    it 'returns result' do
      expect(subject).to be_instance_of(ConvertApi::Result)
      expect(subject.conversion_cost).to be_instance_of(Integer)
      # subject.save_files('/tmp')
    end

    context 'web' do
      let(:from_format) { 'web' }
      let(:resource) { 'http://convertapi.com' }

      it 'returns result' do
        expect(subject).to be_instance_of(ConvertApi::Result)
        # subject.save_files('/tmp')
      end
    end

    context 'when secret is not set' do
      before { ConvertApi.config.api_secret = nil }

      it 'raises error' do
        expect { subject }.to raise_error(ConvertApi::SecretError, /not configured/)
      end
    end

    context 'with invalid secret' do
      before { ConvertApi.config.api_secret = 'invalid' }

      it 'raises error' do
        expect { subject }.to raise_error(ConvertApi::ClientError, /bad secret/)
      end
    end
  end
end
