require 'spec_helper'

describe Virtus::Attribute, '.build' do
  subject { described_class.build(name, type, options) }

  let(:name) { :test }
  let(:type) { String }

  share_examples_for 'a valid attribute instance' do
    it { should be_instance_of(Virtus::Attribute) }
  end

  context 'without options' do
    let(:options) { {} }

    it_behaves_like 'a valid attribute instance'

    it { should be_coercible }
    it { should be_public_reader }
    it { should be_public_writer }

    its(:accessor) { should_not be_lazy }

    it 'sets up a coercer' do
      expect(subject.coercer).to be_instance_of(Coercible::Coercer::String)
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

    its(:accessor) { should be_lazy }
  end
end
