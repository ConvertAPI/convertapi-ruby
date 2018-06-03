RSpec.describe ConvertApi::Client do
  before { ConvertApi.config.api_secret = ENV['CONVERT_API_SECRET'] }

  describe '#post' do
    subject { described_class.new.post(path, params) }

    let(:path) { 'txt/to/pdf' }
    let(:params) { { File: file } }

    shared_examples 'converting file' do
      it 'sends request and returns result' do
        expect(subject['ConversionCost']).to be_instance_of(Integer)
        expect(subject['Files']).to be_instance_of(Array)
      end
    end

    context 'with local file' do
      let(:file) { Faraday::UploadIO.new('LICENSE.txt', 'application/octet-stream') }

      it_behaves_like 'converting file'
    end

    context 'with url as file' do
      let(:file) { 'https://www.w3.org/TR/PNG/iso_8859-1.txt' }
      it_behaves_like 'converting file'
    end
  end
end
