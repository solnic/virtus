require 'spec_helper'

describe Virtus::InstanceMethods, '#freeze' do
  subject { object.freeze }

  let(:object) do
    described_class.new(attributes)
  end

  context 'on class with no defaults' do
    let(:described_class) do
      Class.new do
        include Virtus
        attribute :name, String
      end
    end

    let(:attributes) { { :name => 'John' } }

    it_should_behave_like 'a #freeze method'
  end

  context 'on class with literal default' do
    let(:described_class) do
      Class.new do
        include Virtus
        attribute :name, String, :default => 'John'
      end
    end

    context 'when value is provided' do
      let(:attributes) { { :name => 'John' } }

      it_should_behave_like 'a #freeze method'
    end

    context 'when value is NOT provided' do
      let(:attributes) {}

      it_should_behave_like 'a #freeze method'
    end
  end

  context 'on class with computed default' do
    let(:described_class) do
      Class.new do
        include Virtus
        attribute :name, String, :default => proc { 'John' }
      end
    end

    context 'when value is provided' do
      let(:attributes) { { :name => 'John' } }

      it_should_behave_like 'a #freeze method'
    end

    context 'when value is NOT provided' do
      let(:attributes) {}

      it_should_behave_like 'a #freeze method'
    end
  end
end
