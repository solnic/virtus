require 'spec_helper'

describe Virtus::Attribute::Collection, '.merge_options' do
  subject { described_class.merge_options(type, options) }

  let(:type)        { mock('type')        }
  let(:member_type) { mock('member_type') }
  let(:options)     { Hash.new            }

  context 'when `type` responds to `size`' do
    before do
      type.should_receive(:respond_to?).with(:size).and_return(true)
      type.should_receive(:size).and_return(size)
    end

    context 'when size is == 1' do
      let(:size) { 1 }

      before do
        type.should_receive(:first).and_return(member_type)
      end

      specify { subject[:member_type].should eql(member_type) }
    end

    context 'when size is > 1' do
      let(:size) { 2 }

      specify { expect { subject }.to raise_error(NotImplementedError, "build SumType from list of types (#{type.inspect})") }
    end
  end

  context 'when `type` does not respond to `size`' do
    before do
      type.should_receive(:respond_to?).with(:size).and_return(false)
    end

    it { should eql(options) }
  end
end
