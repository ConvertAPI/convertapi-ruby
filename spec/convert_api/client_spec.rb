RSpec.describe ConvertApi::Client do
  let(:client) { described_class.new }

  describe '#upload' do
    subject { client.upload(io, File.basename(io.path)) }

    let(:io) { File.open('LICENSE.txt') }

    it 'uploads file and results result' do
      expect(subject['FileId']).to be_instance_of(String)
    end
  end
end
