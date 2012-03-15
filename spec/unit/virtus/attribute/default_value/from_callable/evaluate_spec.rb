require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromCallable, '#evaluate' do
  subject { object.evaluate(instance) }

  let(:object)    { described_class.new(attribute, value) }
  let(:attribute) { mock('attribute')                     }
  let(:value)     { mock('value')                         }
  let(:instance)  { mock('instance')                      }
  let(:response)  { stub('response')                      }

  before { value.stub(:call => response) }

  specify { object.should be_instance_of(Virtus::Attribute::DefaultValue::FromCallable) }

  it { should be(response) }

  it 'calls the value with the instance and attribute' do
    value.should_receive(:call).with(instance, attribute)
    subject
  end
end

