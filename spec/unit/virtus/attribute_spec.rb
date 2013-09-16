require 'spec_helper'

describe Virtus, '#attribute' do
  let(:name)    { :test }
  let(:options) { {} }

  share_examples_for 'a class with boolean attribute' do
    subject { Test }

    its(:instance_methods) { should include(:test) }
    its(:instance_methods) { should include(:test?) }
  end

  context 'with a class' do
    context 'when type is Boolean' do
      before :all do
        class Test
          include Virtus

          attribute :test, Boolean
        end
      end

      after :all do
        Object.send(:remove_const, :Test)
      end

      it_behaves_like 'a class with boolean attribute'
    end

    context 'when type is "Boolean"' do
      before :all do
        class Test
          include Virtus

          attribute :test, 'Boolean'
        end
      end

      after :all do
        Object.send(:remove_const, :Test)
      end

      it_behaves_like 'a class with boolean attribute'
    end

    context 'when type is :Boolean' do
      before :all do
        class Test
          include Virtus

          attribute :test, 'Boolean'
        end
      end

      after :all do
        Object.send(:remove_const, :Test)
      end

      it_behaves_like 'a class with boolean attribute'
    end
  end

  context 'with a module' do
    let(:mod) { Module.new { include Virtus } }
    let(:model) { Class.new }

    it 'adds attributes from the module to a class that includes it' do
      mod.attribute(:test, String)
      model.send(:include, mod)

      expect(model.attribute_set[:test]).to be_instance_of(Virtus::Attribute)
    end
  end
end
