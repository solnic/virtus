require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromClonable, '#evaluate' do
  subject { object.evaluate(instance) }

  let(:object)    { described_class.new(attribute, value) }
  let(:attribute) { mock('attribute')                       }
  let(:value)     { mock('value')                           }
  let(:instance)  { mock('instance')                        }
  let(:response)  { mock('response')                        }
  let(:clone)     { mock('clone')                           }

  before { value.stub(:clone => clone) }

  it { should be(clone) }

  it 'clones the value' do
    value.should_receive(:clone).with(no_args)
    subject
  end
end

