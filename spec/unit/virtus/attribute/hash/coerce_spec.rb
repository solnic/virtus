require 'spec_helper'

describe Virtus::Attribute::Hash, '#coerce' do
  subject { object.coerce(input_value) }

  let(:options) { {:key_type => String, :value_type => Float } }
  let(:object)  { Virtus::Attribute::Hash.new('stuff', options) }

  context 'respond to `inject`' do
    let(:input_value) { { :one => '1', 'two' => 2 } }

    it { should == { 'one' => 1.0, 'two' => 2.0 } }
  end

  context 'does not respond to `inject`' do
    let(:input_value) { :symbol }

    it { should == :symbol }
  end
end
