require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '#reader' do
  subject { object.reader }

  let(:object) { described_class.new('test', type) }
  let(:type)   { mock('attribute_type').as_null_object }

  let(:reader_class) { mock('reader_class') }
  let(:reader_opts)  { mock('reader_opts') }
  let(:reader)       { mock('reader') }

  before do
    object.stub!(
      :reader_class   => reader_class,
      :reader_options => reader_opts
    )
    reader_class.should_receive(:new).with('test', reader_opts).
      and_return(reader)
  end

  it { should be(reader) }
end
