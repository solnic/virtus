require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '#reader_options' do
  subject { object.reader_options }

  let(:object)  { described_class.new('test', type, options) }
  let(:type)    { double('attribute_type') }
  let(:options) { {} }

  before do
    type.should_receive(:reader_options).with(options).and_return({})
  end

  context "when reader visibility is not set" do
    it { should include(:visibility => :public) }
  end

  context "when reader visibility is set" do
    let(:options) { { :reader => :private } }

    it { should include(:visibility => :private) }
  end
end
