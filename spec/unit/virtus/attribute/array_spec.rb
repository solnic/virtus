require 'spec_helper'

describe Virtus::Attribute::Array do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :colors }
    let(:attribute_value)       { [ 'red', 'green', 'blue' ] }
    let(:attribute_value_other) { [ 'orange', 'yellow', 'gray' ] }
  end

  describe '#coerce' do
    let(:attribute) { described_class.new(:colors) }

    subject { attribute.coerce(value) }

    context 'with a Hash' do
      let(:value) { { :foo => 'bar' } }

      it { should == [ [:foo, 'bar'] ] }
    end
  end

end
