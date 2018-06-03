RSpec.describe ConvertApi do
  it 'has a version number' do
    expect(ConvertApi::VERSION).not_to be nil
  end

  it 'has configuration defaults' do
    expect(ConvertApi.config.api_secret).to be_nil
    expect(ConvertApi.config.api_base_uri).not_to be_nil
    expect(ConvertApi.config.request_timeout).not_to be_nil
    expect(ConvertApi.config.upload_timeout).not_to be_nil
    expect(ConvertApi.config.download_timeout).not_to be_nil
  end

  describe '.configure' do
    let(:api_secret) { 'test_secret' }
    let(:request_timeout) { 700 }

    it 'configures' do
      ConvertApi.configure do |config|
        config.api_secret = api_secret
        config.request_timeout = request_timeout
      end

      expect(ConvertApi.config.api_secret).to eq(api_secret)
      expect(ConvertApi.config.request_timeout).to eq(request_timeout)
    end
  end
end
