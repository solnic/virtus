require 'spec_helper'

describe Virtus::Attribute, '#coerce' do
  subject { object.coerce(input) }

  fake(:coercer) { Virtus::Attribute::Coercer }

  let(:object)   {
    described_class.build(String,
      :coercer => coercer, :strict => strict, :required => required, :nullify_blank => nullify_blank)
  }

  let(:required) { true }
  let(:nullify_blank) { false }
  let(:input)    { 1 }
  let(:output)   { '1' }

  context 'when strict mode is turned off' do
    let(:strict) { false }

    it 'uses coercer to coerce the input value' do
      mock(coercer).call(input) { output }

      expect(subject).to be(output)

      expect(coercer).to have_received.call(input)
    end
  end

  context 'when strict mode is turned on' do
    let(:strict) { true }

    it 'uses coercer to coerce the input value' do
      mock(coercer).call(input) { output }
      mock(coercer).success?(String, output) { true }

      expect(subject).to be(output)

      expect(coercer).to have_received.call(input)
      expect(coercer).to have_received.success?(String, output)
    end

    context 'when attribute is not required and input is nil' do
      let(:required) { false }
      let(:input)    { nil }

      it 'returns nil' do
        mock(coercer).call(input) { input }
        mock(coercer).success?(String, input) { false }

        expect(subject).to be(nil)

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, input)
      end
    end

    context 'when attribute is required and input is nil' do
      let(:input) { nil }

      it 'returns raises error' do
        mock(coercer).call(input) { input }
        mock(coercer).success?(String, input) { false }

        expect { subject }.to raise_error(Virtus::CoercionError)

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, input)
      end
    end

    it 'raises error when input was not coerced' do
      mock(coercer).call(input) { input }
      mock(coercer).success?(String, input) { false }

      expect { subject }.to raise_error(Virtus::CoercionError)

      expect(coercer).to have_received.call(input)
      expect(coercer).to have_received.success?(String, input)
    end
  end

  context 'when the input is an empty String' do
    let(:input) { '' }
    let(:output) { '' }

    context 'when nullify_blank is turned on' do
      let(:nullify_blank) { true }
      let(:strict) { false }
      let(:require) { false }

      it 'returns nil' do
        mock(coercer).call(input) { input }
        mock(coercer).success?(String, input) { false }

        expect(subject).to be_nil

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, input)
      end

      it 'returns the ouput if it was coerced' do
        mock(coercer).call(input) { output }
        mock(coercer).success?(String, output) { true }

        expect(subject).to be(output)

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, output)
      end
    end

    context 'when both nullify_blank and strict are turned on' do
      let(:nullify_blank) { true }
      let(:strict) { true }

      it 'does not raises an coercion error' do
        mock(coercer).call(input) { input }
        mock(coercer).success?(String, input) { false }

        expect { subject }.not_to raise_error
        expect(subject).to be_nil

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, input)
      end
    end
  end
end
