RSpec.describe ConvertApi::FormatDetector, '#run' do
  subject { described_class.new(resource).run }

  context 'with file name' do
    let(:resource) { 'test.txt' }
    it { is_expected.to eq('txt') }
  end

  context 'with file path' do
    let(:resource) { '/some/path/test.txt' }
    it { is_expected.to eq('txt') }
  end

  context 'with url' do
    let(:resource) { 'https://hostname/some/path/test.txt' }
    it { is_expected.to eq('txt') }
  end

  context 'with File' do
    let(:resource) { File.open('examples/files/test.docx') }
    it { is_expected.to eq('docx') }
  end

  context 'with UploadIO' do
    let(:resource) { ConvertApi::UploadIO.new('test', 'file.txt') }
    it { is_expected.to eq('txt') }
  end

  context 'when path without extension' do
    let(:resource) { 'test' }

    it 'raises error' do
      expect { subject }.to raise_error(ConvertApi::FormatError)
    end
  end
end
