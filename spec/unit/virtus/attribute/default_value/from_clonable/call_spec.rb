require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromClonable, '#call' do
  subject { object.call(instance) }

  let(:object)    { described_class.new(value) }
  let(:value)     { mock('value')              }
  let(:instance)  { mock('instance')           }
  let(:response)  { mock('response')           }
  let(:clone)     { mock('clone')              }

  before { value.stub(:clone => clone) }

  it { should be(clone) }

  it 'clones the value' do
    value.should_receive(:clone).with(no_args)
    subject
  end
end
