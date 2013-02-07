require 'spec_helper'

describe Virtus::Attribute::Accessor, '#lazy?' do
  subject { object.lazy? }

  let(:object) { described_class.new(reader, writer) }
  let(:reader) { mock('reader') }
  let(:writer) { mock('writer') }

  it { should be(false) }
end
