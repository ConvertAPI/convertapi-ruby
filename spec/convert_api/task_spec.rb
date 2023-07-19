RSpec.describe ConvertApi::Task, '#run' do
  subject { task.run }

  let(:task) { described_class.new(from_format, to_format, params) }
  let(:from_format) { 'txt' }
  let(:to_format) { 'pdf' }
  let(:params) { { File: file } }
  let(:file) { 'https://www.w3.org/TR/2003/REC-PNG-20031110/iso_8859-1.txt' }
  let(:result) { double }

  it 'executes task and returns result' do
    expect(ConvertApi.client).to(
      receive(:post).with('convert/txt/to/pdf', instance_of(Hash), instance_of(Hash)).and_return(result)
    )

    expect(subject).to be_instance_of(ConvertApi::Result)
  end

  context 'with converter' do
    let(:params) { { File: file, Converter: 'openoffice' } }

    it 'adds converter to the path' do
      expect(ConvertApi.client).to(
        receive(:post).with('convert/txt/to/pdf/converter/openoffice', instance_of(Hash), instance_of(Hash)).and_return(result)
      )

      expect(subject).to be_instance_of(ConvertApi::Result)
    end
  end
end
