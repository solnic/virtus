require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromClonable, '#call' do
  subject { object.call(instance) }

  let(:object)    { described_class.new(value) }
  let(:value)     { double('value')              }
  let(:instance)  { double('instance')           }
  let(:response)  { double('response')           }
  let(:clone)     { double('clone')              }

  before { value.stub(:clone => clone) }

  it { should be(clone) }

  it 'clones the value' do
    value.should_receive(:clone).with(no_args)
    subject
  end
end
