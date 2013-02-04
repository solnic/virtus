require 'spec_helper'

describe Virtus::Attribute, '#value_coerced?' do
  subject { object.value_coerced?(value) }

  let(:object)   { described_class::String.new(:name, accessor) }
  let(:accessor) { stub('accessor', :writer => writer) }
  let(:writer)   { stub('writer', :coercer => coercer) }
  let(:coercer)  { stub('coercer') }

  let(:string_coercer) { stub('string_coercer') }

  before do
    coercer.should_receive(:[]).with(String).and_return(string_coercer)
  end

  context 'when the value matches the primitive' do
    let(:value) { 'string' }

    before do
      string_coercer.should_receive(:coerced?).with(value).and_return(true)
    end

    it { should be(true) }
  end

  context 'when the value does not match the primitive' do
    let(:value) { 1 }

    before do
      string_coercer.should_receive(:coerced?).with(value).and_return(false)
    end

    it { should be(false) }
  end
end
