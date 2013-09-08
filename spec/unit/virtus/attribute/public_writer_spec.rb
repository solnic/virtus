require 'spec_helper'

describe Virtus::Attribute, '#public_writer?' do
  subject { object.public_writer? }

  let(:object)   { described_class.new(:name, accessor) }
  let(:accessor) { double('accessor', :public_writer? => is_public) }

  context "when writer is public" do
    let(:is_public) { true }

    it { should be(true) }
  end

  context "when writer is not public" do
    let(:is_public) { false }

    it { should be(false) }
  end
end
