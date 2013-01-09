require 'spec_helper'

describe Virtus::Attribute::Hash::CoercibleWriter, '#coerce' do
  subject { object.coerce(value) }

  let(:object)  { described_class.new(:test, options) }
  let(:options) { { :coercion_method => :to_hash, :primitive => Hash, :key_type => String, :value_type => Integer } }

  let(:value) { [ [ 1, '1' ] ] }

  it { should be_instance_of(Hash) }
  it { should include('1' => 1) }
end
