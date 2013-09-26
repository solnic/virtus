require 'spec_helper'

describe Virtus::Attribute, '#coerce' do
  subject { object.coerce(input) }

  fake(:coercer) { Virtus::Attribute::Coercer }

  let(:object)   {
    described_class.build(String,
      :coercer => coercer, :strict => strict, :required => required)
  }

  let(:required) { true }
  let(:input)    { 1 }
  let(:output)   { '1' }

  context 'when strict mode is turned off' do
    let(:strict) { false }

    it 'uses coercer to coerce the input value' do
      stub(coercer).call(input) { output }

      expect(subject).to be(output)

      expect(coercer).to have_received.call(input)
    end
  end

  context 'when strict mode is turned on' do
    let(:strict) { true }

    it 'uses coercer to coerce the input value' do
      stub(coercer).call(input) { output }
      stub(coercer).success?(String, output) { true }

      expect(subject).to be(output)

      expect(coercer).to have_received.call(input)
      expect(coercer).to have_received.success?(String, output)
    end

    context 'when attribute is not required and input is nil' do
      let(:required) { false }
      let(:input)    { nil }

      it 'returns nil' do
        stub(coercer).call(input) { input }
        stub(coercer).success?(String, input) { false }

        expect(subject).to be(nil)

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, input)
      end
    end

    context 'when attribute is required and input is nil' do
      let(:input) { nil }

      it 'returns raises error' do
        stub(coercer).call(input) { input }
        stub(coercer).success?(String, input) { false }

        expect { subject }.to raise_error(Virtus::CoercionError)

        expect(coercer).to have_received.call(input)
        expect(coercer).to have_received.success?(String, input)
      end
    end

    it 'raises error when input was not coerced' do
      stub(coercer).call(input) { input }
      stub(coercer).success?(String, input) { false }

      expect { subject }.to raise_error(Virtus::CoercionError)

      expect(coercer).to have_received.call(input)
      expect(coercer).to have_received.success?(String, input)
    end
  end
end
