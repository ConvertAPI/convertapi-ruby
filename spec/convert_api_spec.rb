require 'stringio'
require 'tmpdir'

RSpec.describe ConvertApi do
  it 'has configuration defaults' do
    expect(described_class.config.base_uri).not_to be_nil
    expect(described_class.config.connect_timeout).not_to be_nil
    expect(described_class.config.conversion_timeout).to be_nil
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
    subject do
      described_class.convert(to_format, params, from_format: from_format)
    end

    let(:from_format) { nil }
    let(:to_format) { 'pdf' }
    let(:params) { { File: 'examples/files/test.docx' } }

    shared_examples 'successful conversion' do
      it 'returns result' do
        expect(subject).to be_instance_of(ConvertApi::Result)
        expect(subject.conversion_cost).to be_a_kind_of(Integer)
        expect(subject.files).not_to be_empty

        files = subject.save_files(Dir.tmpdir)
        files.each { |file| File.unlink(file) }
      end
    end

    it_behaves_like 'successful conversion'

    context 'with web resource' do
      let(:from_format) { 'web' }
      let(:params) { { Url: 'http://convertapi.com' } }

      it_behaves_like 'successful conversion'
    end

    context 'with io source' do
      let(:params) { { File: ConvertApi::UploadIO.new(io, 'test.txt') } }
      let(:io) { StringIO.new('Hello world') }

      it_behaves_like 'successful conversion'
    end

    context 'with multiple files' do
      let(:to_format) { 'zip' }
      let(:params) { { Files: [file1, file2] } }
      let(:file1) { 'examples/files/test.pdf' }
      let(:file2) { ConvertApi::UploadIO.new('examples/files/test.pdf', 'test2.pdf') }

      it_behaves_like 'successful conversion'
    end

    context 'with result' do
      let(:params) { { File: result } }

      let(:result) do
        ConvertApi::Result.new(
          'ConversionCost' => 1,
          'Files' => [
            'Url' => 'https://www.w3.org/TR/2003/REC-PNG-20031110/iso_8859-1.txt',
          ],
        )
      end

      it_behaves_like 'successful conversion'
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

    context 'when file and format not specified' do
      let(:params) { {} }

      it 'raises error' do
        expect { subject }.to raise_error(ConvertApi::FormatError)
      end
    end

    context 'async' do
      shared_examples 'successful async conversion' do
        it 'returns result' do
          expect(subject).to be_instance_of(ConvertApi::AsyncResult)
          expect(subject.job_id).to be_a_kind_of(String)
        end
      end

      context 'with web resource' do
        let(:from_format) { 'web' }
        let(:params) { {Async: true, Url: 'http://convertapi.com' } }

        it_behaves_like 'successful async conversion'
      end

      context 'with multiple files' do
        let(:to_format) { 'zip' }
        let(:params) { { Async: true, Files: [file1, file2] } }
        let(:file1) { 'examples/files/test.pdf' }
        let(:file2) { ConvertApi::UploadIO.new('examples/files/test.pdf', 'test2.pdf') }

        it_behaves_like 'successful async conversion'
      end
    end
  end

  describe '.user' do
    subject { described_class.user }

    it 'returns user information' do
      expect(subject).to include('Email' => instance_of(String))
    end
  end
end
