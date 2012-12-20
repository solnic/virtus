require 'spec_helper'

describe Virtus::Attribute::Hash, '#coerce' do
  subject { object.coerce(value) }

  let(:options) { { :key_type => String, :value_type => Float } }
  let(:object)  { Virtus::Attribute::Hash.new('stuff', options) }

  context 'when coerced value responds to #each_with_object' do
    let(:value) { { :one => '1', 'two' => 2 } }

    it { should eql('one' => 1.0, 'two' => 2.0) }
  end

  context 'when coerced value does not respond to #each_with_object' do
    let(:value) { stub }

    it { should equal(value) }
  end

  context 'without Hash coerce type define' do
    let(:options) { {}                          }
    let(:value)   { { :one => '1', 'two' => 2 } }

    it { should eq(:one => '1', 'two' => 2) }
  end
end
