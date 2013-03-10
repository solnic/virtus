require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '#reader_class' do
  subject { object.reader_class }

  let(:object)       { described_class.new('test', type, options) }
  let(:type)         { mock('attribute_type') }
  let(:reader_class) { mock('reader_class') }
  let(:primitive)    { options[:primitive] }

  context "when options provides reader_class" do
    let(:options) { { :reader_class => reader_class } }

    it { should be(reader_class) }
  end

  context "when options doesn't provide reader_class" do
    let(:options) { {} }

    before do
      type.should_receive(:reader_class).with(primitive, options).
        and_return(reader_class)
    end

    it { should be(reader_class) }
  end
end
