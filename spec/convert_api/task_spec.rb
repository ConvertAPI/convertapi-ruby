RSpec.describe ConvertApi::Task, '#run' do
  subject { task.run }

  let(:task) { described_class.new(from_format, to_format, params) }
  let(:from_format) { 'txt' }
  let(:to_format) { 'pdf' }
  let(:params) { { File: file } }
  let(:file) { 'https://www.w3.org/TR/2003/REC-PNG-20031110/iso_8859-1.txt' }
  let(:result) { double }

  shared_examples 'successful task' do
    it 'executes task and returns result' do
      expect(ConvertApi.client).to(
        receive(:post).with('convert/txt/to/pdf', instance_of(Hash), instance_of(Hash)).and_return(result)
      )

      expect(subject).to be_instance_of(ConvertApi::Result)
    end
  end

  it_behaves_like 'successful task'

  context 'with converter' do
    let(:params) { { File: file, Converter: 'openoffice' } }

    it 'adds converter to the path' do
      expect(ConvertApi.client).to(
        receive(:post).with('convert/txt/to/pdf/converter/openoffice', instance_of(Hash), instance_of(Hash)).and_return(result)
      )

      expect(subject).to be_instance_of(ConvertApi::Result)
    end
  end

  context 'when file is instance of ResultFile' do
    let(:file) { ConvertApi::ResultFile.new('Url' => 'testurl') }
    let(:expected_params) { hash_including(File: 'testurl') }

    it 'uses file url' do
      expect(ConvertApi.client).to(
        receive(:post).with('convert/txt/to/pdf', expected_params, instance_of(Hash)).and_return(result)
      )

      expect(subject).to be_instance_of(ConvertApi::Result)
    end
  end

  context 'when multiple file params' do
    let(:file) { ConvertApi::ResultFile.new('Url' => 'testurl') }
    let(:params) { { File: file, CompareFile: file } }
    let(:expected_params) { hash_including(File: 'testurl', CompareFile: 'testurl') }

    it 'uses multiple file urls' do
      expect(ConvertApi.client).to(
        receive(:post).with('convert/txt/to/pdf', expected_params, instance_of(Hash)).and_return(result)
      )

      expect(subject).to be_instance_of(ConvertApi::Result)
    end

    it 'executes task and returns result' do
      expect(ConvertApi.client).to(
        receive(:post).with('convert/txt/to/pdf', instance_of(Hash), instance_of(Hash)).and_return(result)
      )

      expect(subject).to be_instance_of(ConvertApi::Result)
    end
  end


  describe 'async' do
    shared_examples 'successful async task' do
      it 'submits an async task and returns result' do
        expect(ConvertApi.client).to(
          receive(:post).with('async/convert/txt/to/pdf', instance_of(Hash), instance_of(Hash)).and_return(result)
        )

        expect(subject).to be_instance_of(ConvertApi::AsyncResult)
      end
    end

    context 'Async: false' do
      let(:params) { { Async: false, File: file } }

      it_behaves_like 'successful task'
    end

    context 'Async: "false"' do
      let(:params) { { Async: 'false', File: file } }

      it_behaves_like 'successful task'
    end

    context 'Async: true' do
      let(:params) { { Async: true, File: file } }

      it_behaves_like 'successful async task'
    end

    context 'Async: "true"' do
      let(:params) { { Async: "true", File: file } }

      it_behaves_like 'successful async task'
    end
  end
end
