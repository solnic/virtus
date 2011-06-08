# TODO: split this into separate files

shared_examples_for "Attribute" do
  def attribute_name
    raise "+attribute_name+ should be defined"
  end

  before :all do
    Object.send(:remove_const, :SubAttribute) if Object.const_defined?(:SubAttribute)
    Object.send(:remove_const, :User)         if Object.const_defined?(:User)
  end

  let(:sub_attribute) { class SubAttribute < described_class; end; SubAttribute }

  let(:model) do
    Class.new { include Virtus }
  end

  describe ".options" do
    subject { described_class.options }
    it { should be_instance_of(Hash) }
  end

  describe ".accepted_options" do
    it "returns an array of accepted options" do
      described_class.accepted_options.should be_instance_of(Array)
    end

    it "accepts base options" do
      described_class.accepted_options.should include(*Virtus::Attributes::Attribute::OPTIONS)
    end
  end

  describe ".accept_options" do
    let(:new_option) { :width }

    before :all do
      described_class.accepted_options.should_not include(new_option)
      described_class.accept_options(new_option)
    end

    it "sets new accepted options on itself" do
      described_class.accepted_options.should include(new_option)
    end

    it "sets new accepted option on its descendants" do
      sub_attribute.accepted_options.should include(new_option)
    end

    it "creates option accessors" do
      described_class.should respond_to(new_option)
    end

    it "creates option accessors on descendants" do
      sub_attribute.should respond_to(new_option)
    end

    context 'with default option value' do
      let(:option) { :height }
      let(:value)  { 10 }

      before :all do
        sub_attribute.accept_options(option)
        sub_attribute.height(value)
      end

      context "when new attribute is created" do
        subject { sub_attribute.new(attribute_name, model) }

        it "sets the default value" do
          subject.options[option].should eql(value)
        end
      end

      context "when new attribute is created and overrides option's default value" do
        let(:new_value) { 11 }

        subject { sub_attribute.new(attribute_name, model, option => new_value) }

        it "sets the new value" do
          subject.options[option].should eql(new_value)
        end
      end
    end
  end

  describe "#set" do
    let(:attribute) { model.attribute(attribute_name, described_class) }
    let(:object)    { model.new }

    context "with nil" do
      subject { attribute.set(object, nil) }

      it "doesn't set the ivar" do
        subject
        object.instance_variable_defined?(attribute.instance_variable_name).should be(false)
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

  describe "#get" do
    let(:attribute) { model.attribute(attribute_name, described_class) }
    let(:object)    { model.new }

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

  describe "#complex?" do
    let(:attribute) { model.attribute(attribute_name, described_class, :complex => complex) }

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
end
