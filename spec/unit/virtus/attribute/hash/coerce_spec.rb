require 'spec_helper'

describe Virtus::Attribute::Hash, '#coerce' do
  subject { object.coerce(input) }

  fake(:coercer)    { Virtus::Attribute::Coercer }
  fake(:key_type)   { Virtus::Attribute }
  fake(:value_type) { Virtus::Attribute }

  let(:object) {
    described_class.build(Hash[key_primitive => value_primitive], options)
  }

  let(:options) { {} }

  context 'when input is not a hash' do
    let(:input)  { Class.new { def to_hash; { :hello => 'World' }; end }.new }
    let(:object) { described_class.build(Hash) }

    it { should eq(:hello => 'World') }
  end

  context 'when input is a hash' do
    context 'when key/value types are primitives' do
      let(:options) {
        { :coercer => coercer, :key_type => key_type, :value_type => value_type }
      }

      let(:key_primitive)   { String }
      let(:value_primitive) { Integer }

      let(:input) { Hash[1 => '1', 2 => '2'] }

      it 'uses coercer to coerce key and value' do
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

    context 'when key/value types are EVs' do
      let(:key_primitive)   { OpenStruct }
      let(:value_primitive) { Struct.new(:id) }

      let(:input) { Hash[{ :name => 'Test' } => [1]] }

      it 'coerces key input' do
        expect(subject.keys.first).to eq(key_primitive.new(:name => 'Test'))
      end

      it 'coerces value input' do
        expect(subject.values.first).to eq(value_primitive.new(1))
      end
    end
  end
end
