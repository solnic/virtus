shared_examples_for 'Attribute#get' do
  let(:model) do
    Class.new { include Virtus }
  end

  let(:attribute) do
    model.attribute(attribute_name, described_class).attributes[attribute_name]
  end

  let(:object) do
    model.new
  end

  context "when a non-nil value is set" do
    before { attribute.set(object, attribute_value) }

    subject { attribute.get(object) }

    it { should eql(attribute_value) }
  end

  context "when nil is set" do
    before { attribute.set(object, nil) }

    subject { attribute.get(object) }

    it { should be(nil) }
  end
end
