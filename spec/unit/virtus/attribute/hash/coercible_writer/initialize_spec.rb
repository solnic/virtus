require 'spec_helper'

describe Virtus::Attribute::Hash::CoercibleWriter, '#initialize' do
  subject { described_class.new(name, options) }

  let(:name) { :test }

  context "without options" do
    let(:options) { { :coercer => double('coercer') } }

    its(:key_type)    { should be(Object) }
    its(:key_coercer) { should be_instance_of(Virtus::Attribute::Coercer) }

    its(:value_type)    { should be(Object) }
    its(:value_coercer) { should be_instance_of(Virtus::Attribute::Coercer) }
  end
end
