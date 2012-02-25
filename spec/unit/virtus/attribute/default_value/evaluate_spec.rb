require 'spec_helper'

describe Virtus::Attribute::DefaultValue, '#evaluate' do
  subject { object.evaluate(instance) }

  let(:object)    { described_class.build(attribute, value) }
  let(:attribute) { mock('attribute')                       }
  let(:value)     { mock('value')                           }
  let(:instance)  { mock('instance')                        }
  let(:response)  { stub('response')                        }

  context 'when the value is callable' do
    before { value.stub(:call => response) }

    specify { object.should be_instance_of(Virtus::Attribute::DefaultValue::FromCallable) }

    it { should be(response) }

    it 'calls the value with the instance and attribute' do
      value.should_receive(:call).with(instance, attribute)
      subject
    end
  end

  context 'when the value is cloneable' do
    let(:clone) { stub('clone') }

    before { value.stub(:clone => clone) }

    specify { object.should be_instance_of(Virtus::Attribute::DefaultValue::FromClonable) }

    it { should be(clone) }

    it 'clones the value' do
      value.should_receive(:clone).with(no_args)
      subject
    end
  end

  context 'when the value is a method name' do
    let(:instance) { mock('instance', value => retval) }
    let(:value)    { :set_default                      }
    let(:retval)   { stub('retval')                    }

    specify { object.should be_instance_of(Virtus::Attribute::DefaultValue::FromSymbol) }

    it { should be(retval) }

    it 'calls the method' do
      instance.should_receive(value).with(no_args)
      subject
    end
  end

  # smallest number that is Bignum across major ruby impls
  bignum = 0x7fffffffffffffff + 1

  [ nil, true, false, 0, 0.0, bignum, :symbol ].each do |value|
    context "when the value is #{value.inspect} (#{value.class})" do
      let(:value) { value }

      it { should be(value) }
    end
  end
end
