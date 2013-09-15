require 'spec_helper'

describe Virtus::Attribute::Hash, '#coerce' do
  subject { object.coerce(input) }

  fake(:coercer)    { Virtus::Attribute::Coercer }
  fake(:key_type)   { Virtus::Attribute }
  fake(:value_type) { Virtus::Attribute }

  let(:object) {
    described_class.build(Hash[String => Integer], options)
  }

  let(:options) {
    { :coercer => coercer, :key_type => key_type, :value_type => value_type }
  }

  context 'when input is a hash' do
    let(:input) { Hash[1 => '1', 2 => '2'] }

    it 'uses coercer to coerce members' do
      stub(coercer).call(input) { input }

      stub(key_type).coerce(1) { '1' }
      stub(key_type).coerce(2) { '2' }

      stub(value_type).coerce('1') { 1 }
      stub(value_type).coerce('2') { 2 }

      expect(subject).to eq(Hash['1' => 1, '2' => 2])

      expect(key_type).to have_received.coerce(1)
      expect(key_type).to have_received.coerce(2)

      expect(value_type).to have_received.coerce('1')
      expect(value_type).to have_received.coerce('2')
    end
  end
end
