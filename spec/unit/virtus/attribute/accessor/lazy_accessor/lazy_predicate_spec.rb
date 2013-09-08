require 'spec_helper'

describe Virtus::Attribute::Accessor::LazyAccessor, '#lazy?' do
  subject { object.lazy? }

  let(:object) { described_class.new(reader, writer) }
  let(:reader) { double('reader') }
  let(:writer) { double('writer') }

  it { should be(true) }
end
