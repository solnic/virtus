require 'spec_helper'

describe Virtus::Attribute::Collection, '#coerce' do
  subject { object.coerce(input) }

  fake(:coercer)     { Virtus::Attribute::Coercer }
  fake(:member_type) { Virtus::Attribute }

  let(:object) {
    described_class.build(Array[Integer], :coercer => coercer, :member_type => member_type)
  }

  context 'when input is an array' do
    let(:input) { ['1', '2'] }

    it 'uses coercer to coerce members' do
      stub(coercer).call(input) { input }
      stub(member_type).coerce('1') { 1 }
      stub(member_type).coerce('2') { 2 }

      expect(subject).to eq([1, 2])

      expect(member_type).to have_received.coerce('1')
      expect(member_type).to have_received.coerce('2')
    end
  end
end
