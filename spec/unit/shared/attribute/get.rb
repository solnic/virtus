shared_examples_for 'Attribute#get' do
  subject { attribute.get(instance) }

  let(:attribute) { described_class.new(attribute_name) }
  let(:model)     { Class.new }
  let(:instance)  { model.new }

  before { attribute.set(instance, value) }

  context "when a non-nil value is set" do
    let(:value) { attribute_value }
    it { should eql(attribute_value) }
  end

  context "when nil is set" do
    let(:value) { nil }
    it { should be(value) }
  end
end
