require 'spec_helper'

describe Virtus, '#attribute' do
  let(:name)    { :test }
  let(:options) { {} }

  share_examples_for 'a class with boolean attribute' do
    subject { Test }

    its(:instance_methods) { should include(:test) }
    its(:instance_methods) { should include(:test?) }
  end

  share_examples_for 'an object with string attribute' do
    it { should respond_to(:test) }
    it { should respond_to(:test=) }

    it 'can write and read the attribute' do
      subject.test = :foo
      expect(subject.test).to eql('foo')
    end
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

    before do
      mod.attribute(:test, String)
      model.send(:include, mod)
    end

    it 'adds attributes from the module to a class that includes it' do
      expect(model.attribute_set[:test]).to be_instance_of(Virtus::Attribute)
    end

    it_behaves_like 'an object with string attribute' do
      subject { model.new }
    end
  end

  context 'with an instance' do
    subject { model.new }

    let(:model) { Class.new }

    before do
      subject.extend(Virtus)
      subject.attribute(:test, String)
    end

    it_behaves_like 'an object with string attribute'
  end

  context 'using custom module' do
    subject { model.new }

    let(:model) {
      Class.new {
        include Virtus.module { |config| config.coerce = false }

        attribute :test, String
      }
    }

    it { should respond_to(:test) }
    it { should respond_to(:test=) }

    it 'writes and reads attributes' do
      subject.test = :foo
      expect(subject.test).to be(:foo)
    end
  end
end
