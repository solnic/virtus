shared_examples_for 'Attribute#set' do
  subject { attribute.set(instance, value) }

  let(:attribute) { described_class.new(attribute_name) }
  let(:model)     { Class.new }
  let(:instance)  { model.new }

  before { subject }

  context "with nil" do
    let(:value) { nil }

    it { should be(nil) }

    it "sets the value in an ivar" do
      instance.instance_variable_get(attribute.instance_variable_name).should be(nil)
    end
  end

  context "with a primitive value" do
    let(:value) { attribute_value }

    it { should == attribute_value }

    it "sets the value in an ivar" do
      instance.instance_variable_get(attribute.instance_variable_name).should eql(attribute_value)
    end
  end

  context "with a non-primitive value" do
    let(:value) { attribute_value_other }

    it "sets the value in an ivar coerced to the primitive type" do
      instance.instance_variable_get(attribute.instance_variable_name).should be_kind_of(described_class.primitive)
    end
  end
end
