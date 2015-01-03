require 'spec_helper'

describe Virtus::Attribute::Boolean, '#coerce' do
  subject { object.coerce(input) }

  let(:object)  { described_class.build('Boolean', options) }
  let(:options) { {} }

  context 'when strict is turned off' do
    context 'with a truthy value' do
      let(:input) { 1 }

      it { is_expected.to be(true) }
    end

    context 'with a falsy value' do
      let(:input) { 0 }

      it { is_expected.to be(false) }
    end
  end

  context 'when strict is turned on' do
    let(:options) { { :strict => true } }

    context 'with a coercible input' do
      let(:input) { 1 }

      it { is_expected.to be(true) }
    end

    context 'with a non-coercible input' do
      let(:input) { 'no idea if true or false' }

      it 'raises coercion error' do
        expect { subject }.to raise_error(
          Virtus::CoercionError,
          /Failed to coerce "no idea if true or false"/
        )
      end
    end
  end
end
