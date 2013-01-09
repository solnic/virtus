require 'spec_helper'

describe Virtus::Attribute::Hash::CoercibleWriter, '#initialize' do
  subject { described_class.new(name, options) }

  let(:name) { :test }

  context "without options" do
    let(:options) { {} }

    its(:key_type)   { should be(Object) }
    its(:key_writer) { should be_instance_of(Virtus::Attribute::Writer::Coercible) }

    its(:value_type)   { should be(Object) }
    its(:value_writer) { should be_instance_of(Virtus::Attribute::Writer::Coercible) }
  end
end
