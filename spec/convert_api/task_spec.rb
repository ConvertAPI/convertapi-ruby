RSpec.describe ConvertApi::Task do
  let(:task) { described_class.new(from_format, to_format, params) }
  let(:from_format) { 'doc' }
  let(:to_format) { 'pdf' }
  let(:params) { {} }

  describe '#result' do
    subject { task.result }

    let(:result) { double }

    it 'executes task and returns result' do
      expect(ConvertApi.client).to receive(:post).with('doc/to/pdf', params).and_return(result)
      expect(subject).to be(result)
    end
  end
end
