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
end
