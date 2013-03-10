require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '#writer' do
  subject { object.writer }

  let(:object) { described_class.new('test', type) }
  let(:type)   { mock('attribute_type').as_null_object }

  let(:writer_class) { mock('writer_class') }
  let(:writer_opts)  { mock('writer_opts') }
  let(:writer)       { mock('writer') }

  before do
    object.stub!(
      :writer_class   => writer_class,
      :writer_options => writer_opts
    )
    writer_class.should_receive(:new).with('test', writer_opts).
      and_return(writer)
  end

  it { should be(writer) }
end
