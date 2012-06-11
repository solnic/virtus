require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue::FromStruct, '#coerce' do
  subject { object.coerce(value) }

  let(:primitive) { Struct.new(:x, :y) }

  let(:object) do
    described_class.new(:name, :primitive => primitive)
  end

  context 'when the value is nil' do
    let(:value) { nil }

    it { should be_nil }
  end

  context 'when the value is a primitive instance' do
    let(:value) { primitive.new }

    it { should be(value) }
  end

  context 'when the value is an array' do
    let(:value)    { [ 1 ,2 ] }
    let(:instance) { mock('instance') }

    before do
      primitive.should_receive(:new).with(*value).and_return(instance)
    end

    it { should be(instance) }
  end
end
