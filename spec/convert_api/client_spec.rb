RSpec.describe ConvertApi::Client do
  let(:client) { described_class.new }

  describe '#upload' do
    subject { client.upload(io, File.basename(io.path)) }

    let(:io) { File.open('examples/files/test.docx') }

    it 'uploads file and results result' do
      expect(subject['FileId']).to be_instance_of(String)
    end
  end

  describe '#post' do
    let(:file) { 'https://www.w3.org/TR/2003/REC-PNG-20031110/iso_8859-1.txt' }
    let(:path) { 'convert/txt/to/pdf/converter/openoffice' }
    let(:options) { {} }
    let(:mock_response) { OpenStruct.new(code: 200, body: '{}') }

    subject{ client.post(path, params, options) }

    context 'with normal parameters' do
      let(:params) { { File: file } }
      let(:uri_with_secret) { "/#{path}?Secret=#{ConvertApi.config.api_secret}" }

      it 'makes a post request with no extra URL parameters' do
        expect(Net::HTTP::Post).to(receive(:new).with(uri_with_secret, described_class::DEFAULT_HEADERS).and_call_original)
        expect_any_instance_of(Net::HTTP).to(receive(:request).and_return(mock_response))
        expect(subject).to be_an_instance_of(Hash)
      end
    end

    context 'with parameters that MUST be passed via URL' do
      let(:webhook) { 'https://www.convertapi.com/fake-webhook' }
      let(:params) { { File: file, WebHook: webhook } }
      let(:uri_with_selected_params) { "/#{path}?#{URI.encode_www_form({ WebHook: webhook, Secret: ConvertApi.config.api_secret})}" }

      it 'makes a post request that passes the required parameters via URL' do
        expect(Net::HTTP::Post).to(receive(:new).with(uri_with_selected_params, described_class::DEFAULT_HEADERS).and_call_original)
        expect_any_instance_of(Net::HTTP).to(receive(:request).and_return(mock_response))
        expect(subject).to be_an_instance_of(Hash)
      end
    end
  end
end
