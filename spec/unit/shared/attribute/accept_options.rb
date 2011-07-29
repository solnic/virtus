shared_examples_for 'Attribute.accept_options' do
  let(:sub_attribute) { Class.new(described_class) }
  let(:new_option)    { :width }

  before :all do
    described_class.accepted_options.should_not include(new_option)
    described_class.accept_options(new_option)
  end

  context 'with default option value' do
    let(:option) { :height }
    let(:value)  { 10 }

    before :all do
      sub_attribute.accept_options(option)
      sub_attribute.height(value)
    end

    context "when new attribute is created" do
      subject { sub_attribute.new(attribute_name) }

      it "sets the default value" do
        subject.options[option].should eql(value)
      end
    end

    context "when new attribute is created and overrides option's default value" do
      let(:new_value) { 11 }

      subject { sub_attribute.new(attribute_name, option => new_value) }

      it "sets the new value" do
        subject.options[option].should eql(new_value)
      end
    end
  end
end
