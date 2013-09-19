require 'spec_helper'

describe Virtus::Attribute::Hash, '.build' do
  subject { described_class.build(type) }

  share_examples_for 'a valid hash attribute instance' do
    it { should be_instance_of(Virtus::Attribute::Hash) }

    it { should be_frozen }
  end

  context 'when type is Hash' do
    let(:type) { Hash }

    it { should be_instance_of(Virtus::Attribute::Hash) }

    it 'sets default key type' do
      expect(subject.type.key_type).to be(Axiom::Types::Object)
    end

    it 'sets default value type' do
      expect(subject.type.value_type).to be(Axiom::Types::Object)
    end
  end

  context 'when type is Hash[String => Integer]' do
    let(:type) { Hash[String => Integer] }

    it { should be_instance_of(Virtus::Attribute::Hash) }

    it 'sets key type' do
      expect(subject.type.key_type).to be(Axiom::Types::String)
    end

    it 'sets value type' do
      expect(subject.type.value_type).to be(Axiom::Types::Integer)
    end
  end

  context 'when type is Hash[Struct.new(:id) => Integer]' do
    let(:type)     { Hash[key_type => Integer] }
    let(:key_type) { Struct.new(:id) }

    it { should be_instance_of(Virtus::Attribute::Hash) }

    it 'sets key type' do
      expect(subject.type.key_type).to be(key_type)
    end

    it 'sets value type' do
      expect(subject.type.value_type).to be(Axiom::Types::Integer)
    end
  end

  context 'when type is Hash[String => Struct.new(:id)]' do
    let(:type)       { Hash[String => value_type] }
    let(:value_type) { Struct.new(:id) }

    it { should be_instance_of(Virtus::Attribute::Hash) }

    it 'sets key type' do
      expect(subject.type.key_type).to be(Axiom::Types::String)
    end

    it 'sets value type' do
      expect(subject.type.value_type).to be(value_type)
    end
  end

  context 'when type is Hash[String => Integer, Integer => String]' do
    let(:type) { Hash[String => Integer, :Integer => :String] }

    specify do
      expect { subject }.to raise_error(
        ArgumentError,
        "more than one [key => value] pair in `#{type}`"
      )
    end
  end
end
