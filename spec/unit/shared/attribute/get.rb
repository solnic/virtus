shared_examples_for 'Attribute#get' do
  subject { attribute.get(instance) }

  let(:model)     { Class.new }
  let(:instance)  { model.new }

  context 'without default value' do
    let(:attribute) { described_class.new(attribute_name) }

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

  context 'with default value' do
    context 'set to proc' do
      let(:attribute) do
        described_class.new(attribute_name, :default => attribute_default_proc)
      end

      let(:evaluated_proc_value) do
        attribute.default.evaluate(attribute)
      end

      it { should == evaluated_proc_value }
    end

    context 'not set to proc' do
      let(:attribute) do
        described_class.new(attribute_name, :default => attribute_default)
      end

      it { should == attribute_default }
    end
  end
end
