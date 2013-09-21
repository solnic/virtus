require 'spec_helper'

describe Virtus, '.module' do
  subject { Class.new }

  before do
    subject.send(:include, mod)
    subject.attribute :name, String
  end

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

    it 'accepts attribute hash' do
      instance = subject.new
      instance.attributes = attributes
      expect(instance.attributes).to eql(attributes)
    end
  end

  context 'with default configuration' do
    let(:mod) { Virtus.module }

    it_behaves_like 'a model with constructor'
    it_behaves_like 'a model with mass-assignment'
  end
end
