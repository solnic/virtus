require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '#writer_class' do
  subject { object.writer_class }

  let(:object)       { described_class.new('test', type, options) }
  let(:type)         { mock('attribute_type') }
  let(:writer_class) { mock('writer_class') }
  let(:primitive)    { Object }

  context "when options provides writer_class" do
    let(:options) { { :writer_class => writer_class } }

    it { should be(writer_class) }
  end

  context "when options doesn't provide writer_class" do
    let(:options) { {} }

    before do
      type.should_receive(:writer_class).with(primitive, options).
        and_return(writer_class)
    end

    it { should be(writer_class) }
  end
end
