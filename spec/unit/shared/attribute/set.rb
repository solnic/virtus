shared_examples_for 'Attribute#set' do
  let(:model) do
    Class.new { include Virtus }
  end

  let(:attribute) do
    model.attribute(attribute_name, described_class).attributes[attribute_name]
  end

  let(:object) do
    Class.new
  end

  context "with nil" do
    subject { attribute.set(object, nil) }

    it "set the ivar" do
      subject
      object.instance_variable_get(attribute.instance_variable_name).should be(nil)
    end

    it "returns nil" do
      subject.should be(nil)
    end
  end

  context "with a primitive value" do
    before { attribute.set(object, attribute_value) }

    it "sets the value in an ivar" do
      object.instance_variable_get(attribute.instance_variable_name).should eql(attribute_value)
    end
  end

  context "with a non-primitive value" do
    before { attribute.set(object, attribute_value_other) }

    it "sets the value in an ivar converted to the primitive type" do
      object.instance_variable_get(attribute.instance_variable_name).should be_kind_of(described_class.primitive)
    end
  end
end
