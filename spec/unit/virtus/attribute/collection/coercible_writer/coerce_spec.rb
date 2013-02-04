require 'spec_helper'

describe Virtus::Attribute::Collection::CoercibleWriter, '#coerce' do
  subject { object.coerce(value) }

  let(:object)  { described_class.new(:test, options) }
  let(:options) { { :coercer => Virtus::Attribute::Array.coercer, :primitive => Array, :member_type => String } }

  let(:value) { 1 }

  it { should be_instance_of(Array) }
  it { should include('1') }

  its(:size) { should be(1) }
end
