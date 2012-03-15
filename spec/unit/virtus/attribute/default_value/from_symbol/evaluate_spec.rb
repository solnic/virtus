require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromSymbol, '#evaluate' do
  subject { object.evaluate(instance) }

  let(:object)    { described_class.new(attribute, value) }
  let(:attribute) { mock('attribute')                       }
  let(:instance)  { mock('instance', value => retval)       }
  let(:value)     { :set_default                            }
  let(:retval)    { mock('retval')                          }

  it { should be(retval) }

  it 'calls the method' do
    instance.should_receive(value).with(no_args)
    subject
  end
end
