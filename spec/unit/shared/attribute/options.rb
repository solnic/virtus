shared_examples_for 'Attribute.options' do
  specify { described_class.should respond_to(:options) }

  it 'returns a hash with options' do
    described_class.options.should be_instance_of(Hash)
  end
end
