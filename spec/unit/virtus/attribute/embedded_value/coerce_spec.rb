require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '#coerce' do
  subject { object.coerce(value) }

  let(:attribute_name) { :attribute_name }
  let(:model)          { OpenStruct      }
  let(:instance)       { Object.new      }

  context 'when the value is a hash' do
    let(:value) { Hash[:foo => 'bar'] }

    context 'when the options include the model' do
      let(:object)         { described_class.new(attribute_name, :primitive => model) }
      let(:model)          { mock('model')                                        }
      let(:model_instance) { mock('model_instance') }

      before do
        model.should_receive(:new).with(value).and_return(model_instance)
      end

      it { should be(model_instance) }
    end

    context 'with the default OpenStruct model' do
      let(:model_instance) { OpenStruct.new(value) }

      context 'when the options are an empty Hash' do
        let(:object) { described_class.new(attribute_name, {}) }

        it { should == model_instance }
      end

      context 'when the options are not provided' do
        let(:object) { described_class.new(attribute_name) }

        it { should == model_instance }
      end
    end
  end

  context 'when the value is not a hash' do
    let(:object)   { described_class.new(attribute_name) }
    let(:value)    { mock('value')                       }
    let(:instance) { mock('instance')                    }

    before { model.should_receive(:new).with(value).and_return(instance) }

    it { should be(instance) }
  end

  context 'when the value is a virtus object' do
    let(:object) { described_class.new(attribute_name) }
    let(:value)  { Class.new { include Virtus }.new    }

    before { model.should_not_receive(:new).with(value) }

    it { should be(value) }
  end

  context 'when the value is a virtus value object' do
    let(:object) { described_class.new(attribute_name)           }
    let(:value)  { Class.new { include Virtus::ValueObject }.new }

    before { model.should_not_receive(:new).with(value) }

    it { should be(value) }
  end
end
