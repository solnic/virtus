require 'spec_helper'

describe Virtus::Attribute, '.build' do
  subject { described_class.build(type, options.merge(:name => name)) }

  let(:name)    { :test }
  let(:type)    { String }
  let(:options) { {} }

  shared_examples_for 'a valid attribute instance' do
    it { is_expected.to be_instance_of(Virtus::Attribute) }

    it { is_expected.to be_frozen }
  end

  context 'without options' do
    it_behaves_like 'a valid attribute instance'

    it { is_expected.to be_coercible }
    it { is_expected.to be_public_reader }
    it { is_expected.to be_public_writer }
    it { is_expected.not_to be_lazy }

    it 'sets up a coercer' do
      expect(subject.options[:coerce]).to be(true)
      expect(subject.coercer).to be_instance_of(Virtus::Attribute::Coercer)
    end
  end

  context 'when name is passed as a string' do
    let(:name) { 'something' }

    describe '#name' do
      subject { super().name }
      it { is_expected.to be(:something) }
    end
  end

  context 'when coercion is turned off in options' do
    let(:options) { { :coerce => false } }

    it_behaves_like 'a valid attribute instance'

    it { is_expected.not_to be_coercible }
  end

  context 'when options specify reader visibility' do
    let(:options) { { :reader => :private } }

    it_behaves_like 'a valid attribute instance'

    it { is_expected.not_to be_public_reader }
    it { is_expected.to be_public_writer }
  end

  context 'when options specify writer visibility' do
    let(:options) { { :writer => :private } }

    it_behaves_like 'a valid attribute instance'

    it { is_expected.to be_public_reader }
    it { is_expected.not_to be_public_writer }
  end

  context 'when options specify lazy accessor' do
    let(:options) { { :lazy => true } }

    it_behaves_like 'a valid attribute instance'

    it { is_expected.to be_lazy }
  end

  context 'when options specify strict mode' do
    let(:options) { { :strict => true } }

    it_behaves_like 'a valid attribute instance'

    it { is_expected.to be_strict }
  end

  context 'when options specify nullify blank mode' do
    let(:options) { { :nullify_blank => true } }

    it_behaves_like 'a valid attribute instance'

    it { is_expected.to be_nullify_blank }
  end

  context 'when type is a string' do
    let(:type) { 'Integer' }

    it_behaves_like 'a valid attribute instance'

    describe '#type' do
      subject { super().type }
      it { is_expected.to be(Axiom::Types::Integer) }
    end
  end

  context 'when type is a range' do
    let(:type) { 0..10 }

    it_behaves_like 'a valid attribute instance'

    describe '#type' do
      subject { super().type }
      it { is_expected.to be(Axiom::Types.infer(Range)) }
    end
  end

  context 'when type is a symbol of an existing class constant' do
    let(:type) { :String }

    it_behaves_like 'a valid attribute instance'

    describe '#type' do
      subject { super().type }
      it { is_expected.to be(Axiom::Types::String) }
    end
  end

  context 'when type is an axiom type' do
    let(:type) { Axiom::Types::Integer }

    it_behaves_like 'a valid attribute instance'

    describe '#type' do
      subject { super().type }
      it { is_expected.to be(type) }
    end
  end

  context 'when custom attribute class exists for a given primitive' do
    let(:type)      { Class.new }
    let(:attribute) { Class.new(Virtus::Attribute) }

    before do
      attribute.primitive(type)
    end

    it { is_expected.to be_instance_of(attribute) }

    describe '#type' do
      subject { super().type }
      it { is_expected.to be(Axiom::Types::Object) }
    end
  end

  context 'when custom attribute class exists for a given array with member coercion defined' do
    let(:type)      { Class.new(Array)[String] }
    let(:attribute) { Class.new(Virtus::Attribute) }

    before do
      attribute.primitive(type.class)
    end

    it { is_expected.to be_instance_of(attribute) }

    describe '#type' do
      subject { super().type }
      it { is_expected.to be < Axiom::Types::Collection }
    end
  end

  context 'when custom collection-like attribute class exists for a given enumerable primitive' do
    let(:type)      { Class.new { include Enumerable } }
    let(:attribute) { Class.new(Virtus::Attribute::Collection) }

    before do
      attribute.primitive(type)
    end

    it { is_expected.to be_instance_of(attribute) }

    describe '#type' do
      subject { super().type }
      it { is_expected.to be < Axiom::Types::Collection }
    end
  end
end
