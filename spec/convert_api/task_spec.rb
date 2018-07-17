RSpec.describe ConvertApi::Task do
  let(:task) { described_class.new(from_format, to_format, params) }
  let(:from_format) { 'txt' }
  let(:to_format) { 'pdf' }
  let(:params) { { File: 'https://www.w3.org/TR/PNG/iso_8859-1.txt' } }

  describe '#run' do
    subject { task.run }

    let(:result) { double }

    it 'executes task and returns result' do
      expect(ConvertApi.client).to(
        receive(:post).with('convert/txt/to/pdf', instance_of(Hash), instance_of(Hash)).and_return(result)
      )

      expect(subject).to be_instance_of(ConvertApi::Result)
    end
  end
end
