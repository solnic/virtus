require 'spec_helper'

describe Virtus::Attribute::Collection::CoercibleWriter, '#initialize' do
  subject { described_class.new(name, options) }

  let(:name) { :test }

  context "without options" do
    let(:options) { { :primitive => Array, :coercer => Virtus::Attribute::Array.coercer } }

    its(:member_type)   { should be(Object) }
    its(:member_writer) { should be_instance_of(Virtus::Attribute::Coercer) }
  end
end
