require 'spec_helper'

describe Virtus::Attribute::Accessor, '#public_reader?' do
  subject { object.public_reader? }

  let(:object) { described_class.new(reader, writer) }

  let(:reader)   { mock('reader', :public? => is_public) }
  let(:writer)   { mock('writer') }

  context "when reader is public" do
    let(:is_public) { true }

    it { should be(true) }
  end

  context "when reader is not public" do
    let(:is_public) { false }

    it { should be(false) }
  end
end
