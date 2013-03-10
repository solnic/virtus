require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '#writer_options' do
  subject { object.writer_options }

  let(:object)  { described_class.new('test', type, options) }
  let(:type)    { mock('attribute_type') }
  let(:options) { {} }

  before do
    type.should_receive(:writer_options).with(options).and_return({})
  end

  context "when writer visibility is not set" do
    it { should include(:visibility => :public) }
  end

  context "when writer visibility is set" do
    let(:options) { { :writer => :private } }

    it { should include(:visibility => :private) }
  end
end
