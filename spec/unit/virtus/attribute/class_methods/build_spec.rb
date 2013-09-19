require 'spec_helper'

describe Virtus::Attribute, '.build' do
  subject { described_class.build(type, options.merge(:name => name)) }

  let(:name)    { :test }
  let(:type)    { String }
  let(:options) { {} }

  share_examples_for 'a valid attribute instance' do
    it { should be_instance_of(Virtus::Attribute) }

    it { should be_frozen }
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

  context 'when name is passed as a string' do
    let(:name) { 'something' }

    its(:name) { should be(:something) }
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

  context 'when type is a string' do
    let(:type) { 'Integer' }

    it_behaves_like 'a valid attribute instance'

    its(:type) { should be(Axiom::Types::Integer) }
  end

  context 'when type is a symbol' do
    let(:type) { :String }

    it_behaves_like 'a valid attribute instance'

    its(:type) { should be(Axiom::Types::String) }
  end

  context 'when custom attribute class exists for a given primitive' do
    let(:type)      { Class.new }
    let(:attribute) { Class.new(Virtus::Attribute) }

    before do
      attribute.primitive(type)
    end

    it { should be_instance_of(attribute) }

    its(:type) { should be(Axiom::Types::Object) }
  end
end
