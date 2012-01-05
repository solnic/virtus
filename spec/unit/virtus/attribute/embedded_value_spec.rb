require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue do
  shared_context 'EmbeddedValue attribute' do
    let(:embedded_model) { OpenStruct }

    let(:attribute_name)         { :address }
    let(:attribute_value)        { model.new }
    let(:attribute_value_other)  { model.new }
    let(:attribute_default)      { {} }
    let(:attribute_default_proc) { lambda { |instance, attribute| attribute.name == :address } }

    let(:attribute) { described_class.new(attribute_name, :model => embedded_model) }
  end

  it_should_behave_like 'Attribute' do
    include_context 'EmbeddedValue attribute'
  end

  describe '#set' do
    subject { attribute.set(instance, value) }

    include_context 'EmbeddedValue attribute'

    let(:model)    { Class.new }
    let(:instance) { model.new }

    context 'with a hash' do
      let(:value)                   { Hash.new(:foo => 'bar') }
      let(:embedded_model_instance) { mock('embedded_model_instance') }

      before do
        embedded_model.should_receive(:new).with(value).and_return(embedded_model_instance)
        subject
      end

      it "creates an embedded value instance with attributes" do
        instance.instance_variable_get(attribute.instance_variable_name).
          should be(embedded_model_instance)
      end
    end
  end

end
