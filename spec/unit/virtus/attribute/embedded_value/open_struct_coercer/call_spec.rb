require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue::OpenStructCoercer, '#call' do
  subject { object.call(value) }

  let(:primitive) { OpenStruct }

  let(:object) do
    described_class.new(primitive)
  end

  context 'when the value is nil' do
    let(:value) { nil }

    it { should be_nil }
  end

  context 'when the value is a primitive instance' do
    let(:value) { primitive.new }

    it { should be(value) }
  end

  context 'when the value is a hash' do
    let(:value)    { Hash[:foo => 'bar'] }
    let(:instance) { double('instance') }

    before do
      primitive.should_receive(:new).with(value).and_return(instance)
    end

    it { should be(instance) }
  end
end
