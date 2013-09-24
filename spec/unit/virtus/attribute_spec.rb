require 'spec_helper'

describe Virtus, '#attribute' do
  let(:name)    { :test }
  let(:options) { {} }

  share_examples_for 'a class with boolean attribute' do
    subject { Test }

    let(:object) { subject.new }

    it 'defines reader and writer' do
      object.test = true
      expect(object.test).to be(true)
    end

    it 'defines predicate method' do
      object.test = false

      expect(object).to_not be_test
    end
  end

  share_examples_for 'an object with string attribute' do
    it { should respond_to(:test) }
    it { should respond_to(:test=) }

    it 'can write and read the attribute' do
      subject.test = :foo
      expect(subject.test).to eql('foo')
    end
  end

  it 'returns self' do
    klass = Class.new { include Virtus }
    expect(klass.attribute(:test, String)).to be(klass)
  end

  it 'raises error when :name is a reserved name on a class' do
    klass = Class.new { include Virtus }
    expect { klass.attribute(:attributes, Set) }.to raise_error(
      ArgumentError, ':attributes is not allowed as an attribute name'
    )
  end

  it 'raises error when :name is a reserved name on an instance' do
    object = Class.new.new.extend(Virtus)
    expect { object.attribute(:attributes, Set) }.to raise_error(
      ArgumentError, ':attributes is not allowed as an attribute name'
    )
  end

  it 'allows :attributes as an attribute name when mass-assignment is not included' do
    klass = Class.new { include Virtus::Model::Core }
    klass.attribute(:attributes, Set)
    expect(klass.attribute_set[:attributes]).to be_instance_of(Virtus::Attribute::Collection)
  end

  it 'allows specifying attribute without type' do
    klass = Class.new { include Virtus::Model::Core }
    klass.attribute(:name)
    expect(klass.attribute_set[:name]).to be_instance_of(Virtus::Attribute)
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

    context 'when type is Axiom::Types::Boolean' do
      before :all do
        class Test
          include Virtus

          attribute :test, Axiom::Types::Boolean
        end
      end

      after :all do
        Object.send(:remove_const, :Test)
      end

      it_behaves_like 'a class with boolean attribute' do
        before do
          pending 'this will be fixed once Attribute::Boolean subclass is gone'
        end
      end
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

      context 'with a subclass' do
        it_behaves_like 'a class with boolean attribute' do
          subject { Class.new(Test) }

          it 'gets attributes from the parent class' do
            Test.attribute :other, Integer
            expect(subject.attribute_set[:other]).to eql(Test.attribute_set[:other])
          end
        end
      end
    end

    context 'when type is Decimal' do
      before :all do
        class Test
          include Virtus

          attribute :test, Decimal
        end
      end

      after :all do
        Object.send(:remove_const, :Test)
      end

      it 'maps type to the corresponding axiom type' do
        expect(Test.attribute_set[:test].type).to be(Axiom::Types::Decimal)
      end
    end
  end

  context 'with a module' do
    let(:mod) {
      Module.new {
        include Virtus

        attribute :test, String
      }
    }

    let(:model) { Class.new }

    context 'included in the class' do
      before do
        model.send(:include, mod)
      end

      it 'adds attributes from the module to a class that includes it' do
        expect(model.attribute_set[:test]).to be_instance_of(Virtus::Attribute)
      end

      it_behaves_like 'an object with string attribute' do
        subject { model.new }
      end
    end

    context 'included in the class' do
      it_behaves_like 'an object with string attribute' do
        subject { model.new.extend(mod) }
      end
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
        include Virtus.model { |config| config.coerce = false }

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
