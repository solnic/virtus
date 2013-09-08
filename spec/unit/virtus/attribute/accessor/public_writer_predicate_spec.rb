require 'spec_helper'

describe Virtus::Attribute::Accessor, '#public_writer?' do
  subject { object.public_writer? }

  let(:object) { described_class.new(writer, writer) }

  let(:reader)   { double('reader') }
  let(:writer)   { double('writer', :public? => is_public) }

  context "when writer is public" do
    let(:is_public) { true }

    it { should be(true) }
  end

  context "when writer is not public" do
    let(:is_public) { false }

    it { should be(false) }
  end
end
