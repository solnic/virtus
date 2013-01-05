require 'spec_helper'

describe Virtus::Attribute::Collection, '.merge_options' do
  subject { described_class.merge_options(type, options) }

  let(:type)        { mock('type')        }
  let(:member_type) { mock('member_type') }
  let(:options)     { Hash.new }

  context 'when `type` responds to `count`' do
    before do
      type.should_receive(:respond_to?).with(:count).and_return(true)
      type.should_receive(:count).and_return(count)
    end

    context 'when count is == 1' do
      let(:count) { 1 }

      before do
        type.should_receive(:first).and_return(member_type)
      end

      specify { subject[:member_type].should eql(member_type) }
    end

    context 'when count is > 1' do
      let(:count) { 2 }

      specify do
        expect { subject }.to raise_error(
          NotImplementedError, "build SumType from list of types (#{type.inspect})"
        )
      end
    end
  end

  context 'when `type` does not respond to `count`' do
    before do
      type.should_receive(:respond_to?).with(:count).and_return(false)
    end

    it do
      should eql(
        :primitive       => Object,
        :accessor        => :public,
        :coerce          => true,
        :coercion_method => :to_object,
        :reader          => :public,
        :writer          => :public
      )
    end
  end
end
