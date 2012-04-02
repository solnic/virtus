require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromSymbol, '#call' do
  subject { object.call(instance) }

  let(:object)    { described_class.new(value)              }
  let(:instance)  { mock('instance', value => retval)       }
  let(:value)     { :set_default                            }
  let(:retval)    { mock('retval')                          }

  it { should be(retval) }

  it 'calls the method' do
    instance.should_receive(value).with(no_args)
    subject
  end
end
