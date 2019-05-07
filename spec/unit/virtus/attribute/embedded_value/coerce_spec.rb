require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '#coerce' do
  subject { object.coerce(input) }

  let(:object)  { described_class.build(model, options) }
  let(:options) { {} }

  context 'when primitive is OpenStruct' do
    let(:model) { OpenStruct }

    context 'when input is an attribute hash' do
      let(:input) { Hash[:name => 'Piotr', :age => 30] }

      it { is_expected.to be_instance_of(model) }

      describe '#name' do
        subject { super().name }
        it { is_expected.to eql('Piotr') }
      end

      describe '#age' do
        subject { super().age }
        it { is_expected.to eql(30) }
      end
    end

    context 'when input is nil' do
      let(:input) { nil }

      it { is_expected.to be(nil) }
    end

    context 'when input is a model instance' do
      let(:input) { OpenStruct.new }

      it { is_expected.to be(input) }
    end
  end

  context 'when primitive is Struct' do
    let(:model) { Struct.new(:name, :age) }

    context 'when input is an attribute hash' do
      let(:input) { ['Piotr', 30] }

      it { is_expected.to be_instance_of(model) }

      describe '#name' do
        subject { super().name }
        it { is_expected.to eql('Piotr') }
      end

      describe '#age' do
        subject { super().age }
        it { is_expected.to eql(30) }
      end
    end

    context 'when input is nil' do
      let(:input) { nil }

      it { is_expected.to be(nil) }
    end

    context 'when input is a model instance' do
      let(:input) { model.new('Piotr', 30) }

      it { is_expected.to be(input) }
    end
  end

  context 'when :strict mode is enabled' do
    let(:model)   { Struct.new(:name) }
    let(:options) { { :strict => true } }

    context 'when input is coercible' do
      let(:input) { ['Piotr'] }

      it { is_expected.to eql(model.new('Piotr')) }
    end

    context 'when input is not coercible' do
      let(:input) { nil }

      it 'raises error' do
        expect { subject }.to raise_error(Virtus::CoercionError)
      end
    end
  end
end
