require 'spec_helper'

describe Virtus::Attribute::Hash, '.coercible_writer_class' do
  subject { described_class.coercible_writer_class(type, options) }

  let(:type) { double('type') }

  context "when key_type and value_type are set in options" do
    let(:options) { { :key_type => String, :value_type => String } }

    it { should be(Virtus::Attribute::Hash::CoercibleWriter) }
  end

  context "when key_type and value_type are not set in options" do
    let(:options) { Hash.new }

    it { should be(Virtus::Attribute::Writer::Coercible) }
  end
end
