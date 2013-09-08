require 'spec_helper'

describe Virtus::Attribute::Collection, '.coercible_writer_class' do
  subject { described_class.coercible_writer_class(type, options) }

  let(:type) { double('type') }

  context "when member_type is set in options" do
    let(:options) { { :member_type => String } }

    it { should be(Virtus::Attribute::Collection::CoercibleWriter) }
  end

  context "when member_type is not set in options" do
    let(:options) { Hash.new }

    it { should be(Virtus::Attribute::Writer::Coercible) }
  end
end
