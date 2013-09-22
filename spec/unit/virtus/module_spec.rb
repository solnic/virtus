require 'spec_helper'

describe Virtus, '.module' do
  share_examples_for 'a model with constructor' do
    it 'accepts attribute hash' do
      instance = subject.new(:name => 'Jane')
      expect(instance.name).to eql('Jane')
    end
  end

  share_examples_for 'a model with mass-assignment' do
    let(:attributes) do
      { :name => 'Jane' }
    end

    before do
      instance.attributes = attributes
    end

    it 'accepts attribute hash' do
      expect(instance.attributes).to eql(attributes)
    end
  end

  context 'with default configuration' do
    let(:mod) { Virtus.module }

    context 'with a class' do
      subject { Class.new }

      before do
        subject.send(:include, mod)
        subject.attribute :name, String
      end

      it_behaves_like 'a model with constructor'

      it_behaves_like 'a model with mass-assignment' do
        let(:instance) { subject.new }
      end
    end

    context 'with an instance' do
      subject { Class.new.new }

      before do
        subject.extend(mod)
        subject.attribute :name, String
      end

      it_behaves_like 'a model with mass-assignment' do
        let(:instance) { subject }
      end
    end
  end

  context 'when constructor is disabled' do
    subject { Class.new.send(:include, mod) }

    let(:mod) { Virtus.module { |config| config.constructor = false } }

    it 'does not accept attribute hash in the constructor' do
      expect { subject.new({}) }.to raise_error(ArgumentError)
    end
  end

  context 'when mass-assignment is disabled' do
    let(:mod)   { Virtus.module { |config| config.mass_assignment = false } }
    let(:model) { Class.new }

    context 'with a class' do
      subject { model.new }

      before do
        model.send(:include, mod)
      end

      it { should_not respond_to(:attributes) }
      it { should_not respond_to(:attributes=) }
    end

    context 'with an instance' do
      subject { model.new }

      before do
        subject.extend(mod)
      end

      it { should_not respond_to(:attributes) }
      it { should_not respond_to(:attributes=) }
    end
  end
end
