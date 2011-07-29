shared_examples_for 'Attribute.default_defined?' do
  subject { attribute.default_defined? }

  let(:attribute) { described_class.new(attribute_name) }

  context 'when :default option is not set' do
    let(:attribute) { described_class.new(attribute_name) }
    it { should be(false) }
  end

  context 'when :default option is set to nil' do
    let(:attribute) { described_class.new(attribute_name, :default => nil) }
    it { should be(true) }
  end

  context 'when :default option is set to a non-nil value' do
    let(:attribute) { described_class.new(attribute_name, :default => attribute_default) }
    it { should be(true) }
  end
end
