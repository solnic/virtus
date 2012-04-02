require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromCallable, '#call' do
  subject { object.call(instance) }

  let(:object)    { described_class.new(value) }
  let(:value)     { mock('value')              }
  let(:instance)  { mock('instance')           }
  let(:response)  { stub('response')           }

  before { value.stub(:call => response) }

  it { should be(response) }

  it 'calls the value with the instance and attribute' do
    value.should_receive(:call).with(instance)
    subject
  end
end
