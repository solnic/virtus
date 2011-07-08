shared_examples_for 'Attribute#complex?' do
  let(:attribute) { described_class.new(attribute_name, :complex => complex) }

  subject { attribute.complex? }

  context "when set to true" do
    let(:complex) { true }
    it { should be(true) }
  end

  context "when set to false" do
    let(:complex) { false }
    it { should be(false) }
  end
end
