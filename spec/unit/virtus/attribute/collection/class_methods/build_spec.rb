require 'spec_helper'

describe Virtus::Attribute, '.build' do
  subject { described_class.build(type, options) }

  let(:options) { {} }

  shared_examples_for 'a valid collection attribute instance' do
    it { should be_instance_of(Virtus::Attribute::Collection) }

    it { should be_frozen }
  end

  context 'when type is Array' do
    let(:type) { Array }

    it_behaves_like 'a valid collection attribute instance'

    it 'sets default member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Object)
    end
  end

  context 'when type is Array[Virtus::Attribute::Boolean]' do
    let(:type) { Array[Virtus::Attribute::Boolean] }

    it_behaves_like 'a valid collection attribute instance'

    it 'sets member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Boolean)
    end
  end

  context 'when type is Array[Float]' do
    let(:type) { Array[Float] }

    it_behaves_like 'a valid collection attribute instance'

    it 'sets member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Float)
    end
  end

  context 'when type is Array[String, Integer]' do
    let(:type) { Array[String, Integer] }

    specify do
      expect { subject }.to raise_error(
        NotImplementedError,
        "build SumType from list of types (#{type.inspect})"
      )
    end
  end

  context 'when type is Set' do
    let(:type) { Set }

    it_behaves_like 'a valid collection attribute instance'

    it 'sets default member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Object)
    end
  end

  context 'when type is Set[Float]' do
    let(:type) { Set[Float] }

    it_behaves_like 'a valid collection attribute instance'

    it 'sets member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Float)
    end
  end

  context 'when type is an Enumerable' do
    let(:type) { Class.new { include Enumerable } }

    it_behaves_like 'a valid collection attribute instance'
  end

  context 'when type is Array subclass' do
    let(:type) { Class.new(Array) }

    it_behaves_like 'a valid collection attribute instance'
  end

  context 'when type is a custom collection instance' do
    let(:type) { Class.new(Array)[String] }

    it_behaves_like 'a valid collection attribute instance'

    it 'sets member type' do
      expect(subject.type.member_type).to be(Axiom::Types::String)
    end
  end

  context 'when strict mode is used' do
    let(:type) { Array[String] }
    let(:options) { { strict: true } }

    it 'sets strict mode for member type' do
      expect(subject.member_type).to be_strict
    end
  end
end
