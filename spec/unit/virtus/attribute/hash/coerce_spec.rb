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

  context 'when input is coercible to hash' do
    let(:input)  { Class.new { def to_hash; { :hello => 'World' }; end }.new }
    let(:object) { described_class.build(Hash) }

    it { is_expected.to eq(:hello => 'World') }
  end

  context 'when input is not coercible to hash' do
    let(:input)  { 'not really a hash' }
    let(:object) { described_class.build(Hash) }

    it { is_expected.to be(input) }
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
        mock(coercer).call(input) { input }

        mock(key_type).finalize { key_type }
        mock(key_type).coerce(1) { '1' }
        mock(key_type).coerce(2) { '2' }

        mock(value_type).finalize { value_type }
        mock(value_type).coerce('1') { 1 }
        mock(value_type).coerce('2') { 2 }

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

      let(:input)  { Hash[{:name => 'Test'} => [1]] }
      let(:output) { Hash[key_primitive.new(:name => 'Test') => value_primitive.new(1)] }

      it 'coerces keys and values' do
        # FIXME: expect(subject).to eq(output) crashes in rspec
        expect(subject.keys.first).to eq(output.keys.first)
        expect(subject.values.first).to eq(output.values.first)
        expect(subject.size).to be(1)
      end
    end

    context 'when key type is an array and value type is another hash' do
      let(:key_primitive)   { Array[String] }
      let(:value_primitive) { Hash[String => Integer] }

      let(:key_attribute)   { Virtus::Attribute.build(key_primitive) }
      let(:value_attribute) { Virtus::Attribute.build(value_primitive) }

      let(:input)  { Hash[[1, 2], {:one => '1', :two => '2'}] }
      let(:output) { Hash[key_attribute.coerce(input.keys.first) => value_attribute.coerce(input.values.first)] }

      it 'coerces keys and values' do
        expect(subject).to eq(output)
      end
    end
  end
end
