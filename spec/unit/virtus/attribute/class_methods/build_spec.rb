require 'spec_helper'

describe Virtus::Attribute, '.build' do
  subject { described_class.build(type, options.merge(:name => name)) }

  let(:name)    { :test }
  let(:type)    { String }
  let(:options) { {} }

  before :all do
    Axiom::Types.finalize
  end

  share_examples_for 'a valid attribute instance' do
    it { should be_instance_of(Virtus::Attribute) }
  end

  context 'without options' do
    it_behaves_like 'a valid attribute instance'

    it { should be_coercible }
    it { should be_public_reader }
    it { should be_public_writer }
    it { should_not be_lazy }

    it 'sets up a coercer' do
      expect(subject.coercer).to be_instance_of(Virtus::Attribute::Coercer)
    end
  end

  context 'when coercion is turned off in options' do
    let(:options) { { :coerce => false } }

    it_behaves_like 'a valid attribute instance'

    it { should_not be_coercible }
  end

  context 'when options specify reader visibility' do
    let(:options) { { :reader => :private } }

    it_behaves_like 'a valid attribute instance'

    it { should_not be_public_reader }
    it { should be_public_writer }
  end

  context 'when options specify writer visibility' do
    let(:options) { { :writer => :private } }

    it_behaves_like 'a valid attribute instance'

    it { should be_public_reader }
    it { should_not be_public_writer }
  end

  context 'when options specify lazy accessor' do
    let(:options) { { :lazy => true } }

    it_behaves_like 'a valid attribute instance'

    it { should be_lazy }
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

  context 'when type is Array' do
    let(:type) { Array }

    it { should be_instance_of(Virtus::Attribute::Collection) }

    it 'sets default member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Object)
    end
  end

  context 'when type is Array[Float]' do
    let(:type) { Array[Float] }

    it { should be_instance_of(Virtus::Attribute::Collection) }

    it 'sets member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Float)
    end
  end

  context 'when type is Set' do
    let(:type) { Set }

    it { should be_instance_of(Virtus::Attribute::Collection) }

    it 'sets default member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Object)
    end
  end

  context 'when type is Set[Float]' do
    let(:type) { Set[Float] }

    it { should be_instance_of(Virtus::Attribute::Collection) }

    it 'sets member type' do
      expect(subject.type.member_type).to be(Axiom::Types::Float)
    end
  end

  context 'when type is a virtus model' do
    let(:type) { Class.new { include Virtus } }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue) }
  end
end
