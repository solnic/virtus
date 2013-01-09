require 'spec_helper'

describe Virtus::Attribute::Collection::CoercibleWriter, '#initialize' do
  subject { described_class.new(name, options) }

  let(:name) { :test }

  context "without options" do
    let(:options) { {} }

    its(:member_type)   { should be(Object) }
    its(:member_writer) { should be_instance_of(Virtus::Attribute::Writer::Coercible) }
  end
end
