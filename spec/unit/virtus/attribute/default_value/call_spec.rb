require 'spec_helper'

describe Virtus::Attribute::DefaultValue, '#call' do
  subject { object.call(instance) }

  let(:object)    { described_class.build(value) }
  let(:value)     { mock('value')                }
  let(:instance)  { mock('instance')             }
  let(:response)  { stub('response')             }

  # smallest number that is Bignum across major ruby impls
  bignum = 0x7fffffffffffffff + 1

  [ nil, true, false, 0, 0.0, bignum, :symbol ].each do |value|
    context "when the value is #{value.inspect} (#{value.class})" do
      let(:value) { value }

      it { should be(value) }
    end
  end
end
