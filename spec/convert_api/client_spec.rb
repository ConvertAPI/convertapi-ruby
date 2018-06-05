RSpec.describe ConvertApi::Client do
  let(:client) { described_class.new }

  describe '#post' do
    subject { client.post(path, params) }

    let(:path) { 'txt/to/pdf' }
    let(:params) { { File: file } }
    let(:file) { 'https://www.w3.org/TR/PNG/iso_8859-1.txt' }

    it 'sends request and returns result' do
      expect(subject['ConversionCost']).to be_instance_of(Integer)
      expect(subject['Files']).to be_instance_of(Array)
    end
  end

  describe '#upload' do
    subject { client.upload(io, File.basename(io.path)) }

    let(:io) { File.open('LICENSE.txt') }

    it 'uploads file and results result' do
      expect(subject['FileId']).to be_instance_of(String)
    end
  end
end
