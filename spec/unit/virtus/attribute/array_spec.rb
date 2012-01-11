require 'spec_helper'

describe Virtus::Attribute::Array do
  describe '#coerce' do
    let(:attribute) { described_class.new(:colors) }

    subject { attribute.coerce(value) }

    context 'with a Hash' do
      let(:value) { { :foo => 'bar' } }

      it { should == [ [:foo, 'bar'] ] }
    end
  end

end
