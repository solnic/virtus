require 'spec_helper'

describe Virtus::Attribute, '#coerce' do
  subject { object.coerce(input) }

  fake(:coercer) { Virtus::Attribute::Coercer }

  let(:object)   {
    described_class.build(String,
      :coercer => coercer,
      :strict => strict,
      :required => required,
      :default => default,
      :nullify_blank => nullify_blank,
      :use_default_on_nil => use_default_on_nil)
  }

  let(:required)           { true }
  let(:default)            { nil }
  let(:nullify_blank)      { false }
  let(:use_default_on_nil) { false }
  let(:input)              { 1 }
  let(:output)             { '1' }

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

  context 'when use_default_on_nil is turned on' do
    let(:use_default_on_nil) { true }
    let(:strict) { false }

    context 'when the input is nil' do
      let(:input) { nil }
      let(:output) { 'coerced' }

      context 'when a default is set' do
        let(:default) { 'foo' }

        it 'returns the default value if input was not coerced' do
          mock(coercer).call(input) { input }
          mock(coercer).success?(String, input) { false }
          mock(coercer).call(default) { default }

          expect(subject).to be(default)

          expect(coercer).to have_received.call(input)
          expect(coercer).to have_received.success?(String, input)
          expect(coercer).to have_received.call(default)
        end

        it 'returns the output if input was coerced' do
          mock(coercer).call(input) { output }
          mock(coercer).success?(String, output) { true }

          expect(subject).to be(output)

          expect(coercer).to have_received.call(input)
          expect(coercer).to have_received.success?(String, output)
        end
      end

      context 'when a default is not set' do
        it 'returns nil if input was not coerced' do
          mock(coercer).call(input) { input }
          mock(coercer).success?(String, input) { false }

          expect(subject).to be_nil

          expect(coercer).to have_received.call(input)
          expect(coercer).to have_received.success?(String, input)
        end
      end
    end

    context 'when the input is not nil' do
      let(:input) { 1 }

      it 'does not fallback to nil even if input was not coerced' do
        mock(coercer).call(input) { input }
        mock(coercer).success?(String, input) { false }

        expect(subject).to be(input)

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, input)
      end
    end
  end

  context 'when both use_default_on_nil and strict are turned on' do
    let(:use_default_on_nil) { true }
    let(:strict) { false }

    context 'when the input is nil and a default is set' do
      let(:input) { nil }
      let(:default) { 'foo' }

      it 'does not raise a coercion error' do
        mock(coercer).call(input) { input }
        mock(coercer).success?(String, input) { false }
        mock(coercer).call(default) { default }

        expect { subject }.not_to raise_error
        expect(subject).to be(default)

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, input)
        expect(coercer).to have_received.call(default)
      end
    end
  end
end
