require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '.call' do
  subject { described_class.call(name, type, options) }

  let(:name) { 'test' }

  let(:type) {
    mock(
      'attribute_type',
      :reader_class => reader_class,
      :writer_class => writer_class
    )
  }

  let(:options)      { {} }
  let(:reader_class) { mock('reader_class') }
  let(:writer_class) { mock('writer_class') }
  let(:reader)       { mock('reader') }
  let(:writer)       { mock('writer') }

  before do
    type.should_receive(:reader_options).with(options).and_return({})
    type.should_receive(:writer_options).with(options).and_return({})

    reader_class.should_receive(:new).with(name, :visibility => :public).and_return(reader)
    writer_class.should_receive(:new).with(name, :visibility => :public).and_return(writer)
  end

  it { should be_instance_of(Virtus::Attribute::Accessor) }

  its(:reader) { should be(reader) }
  its(:writer) { should be(writer) }
end
