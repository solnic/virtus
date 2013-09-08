require 'spec_helper'

describe Virtus::Attribute::Accessor, '#initialize' do
  subject { described_class.new(reader, writer) }

  let(:reader) { double('reader') }
  let(:writer) { double('writer') }

  its(:reader) { should be(reader) }
  its(:writer) { should be(writer) }
end
