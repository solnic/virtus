require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '#set' do
  subject { object.set(instance, value) }

  let(:attribute_name) { :attribute_name }
  let(:model)          { OpenStruct      }
  let(:instance)       { Object.new      }

  context 'when the value is a hash' do
    let(:value)          { { :foo => 'bar' }      }
    let(:model_instance) { mock('model_instance') }

    before do
      model.should_receive(:new).with(value).and_return(model_instance)
    end

    context 'when the options include the model' do
      let(:object) { described_class.new(attribute_name, :model => model) }
      let(:model)  { mock('model')                                        }

      it 'sets the embedded value instance' do
        object.get(instance).should be_nil
        subject
        object.get(instance).should be(model_instance)
      end
    end

    context 'when the options are an empty Hash' do
      let(:object) { described_class.new(attribute_name, {}) }

      it 'sets the embedded model instance within the instance' do
        object.get(instance).should be_nil
        subject
        object.get(instance).should be(model_instance)
      end
    end

    context 'when the options are not provided' do
      let(:object) { described_class.new(attribute_name) }

      it 'sets the embedded model instance within the instance' do
        object.get(instance).should be_nil
        subject
        object.get(instance).should be(model_instance)
      end
    end
  end

  context 'when the value is not a hash' do
    let(:object) { described_class.new(attribute_name) }
    let(:value)  { mock('value')                       }

    before do
      model.should_not_receive(:new)
    end

    it 'sets the value in the instance' do
      object.get(instance).should be_nil
      subject
      object.get(instance).should be(value)
    end
  end
end
