shared_examples_for 'Attribute.primitive?' do
  subject { described_class.primitive?(value) }

  let(:attribute) { described_class.new(attribute_name) }

  context 'with a primitive value' do
    let(:value) { attribute_value }
    it { should be(true) }
  end

  context 'with a non-primitive value' do
    let(:value) { nil }
    it { should be(false) }
  end
end
