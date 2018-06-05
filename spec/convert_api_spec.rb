RSpec.describe ConvertApi do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  it 'has configuration defaults' do
    expect(described_class.config.api_base_uri).not_to be_nil
    expect(described_class.config.connect_timeout).not_to be_nil
    expect(described_class.config.conversion_timeout).not_to be_nil
    expect(described_class.config.upload_timeout).not_to be_nil
    expect(described_class.config.download_timeout).not_to be_nil
  end

  describe '.configure' do
    let(:api_secret) { 'test_secret' }
    let(:conversion_timeout) { 700 }

    it 'configures' do
      described_class.configure do |config|
        config.api_secret = api_secret
        config.conversion_timeout = conversion_timeout
      end

      expect(described_class.config.api_secret).to eq(api_secret)
      expect(described_class.config.conversion_timeout).to eq(conversion_timeout)
    end
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
    end
  end

  describe '.client' do
    subject { described_class.client }

    it { is_expected.to be_instance_of(ConvertApi::Client) }
  end
end
