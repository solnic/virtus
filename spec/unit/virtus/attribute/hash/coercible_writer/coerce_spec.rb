require 'spec_helper'

describe Virtus::Attribute::Hash::CoercibleWriter, '#coerce' do
  subject { object.coerce(value) }

  let(:object)  { described_class.new(:test, options) }
  let(:options) { { :primitive => Hash, :coercer => Virtus::Attribute::Hash.coercer, :key_type => String, :value_type => Integer } }

  let(:value) { [ [ 1, '1' ] ] }

  it { should be_instance_of(Hash) }
  it { should include('1' => 1) }
end
