require 'spec_helper'

describe Virtus, '.model' do
  shared_examples_for 'a model with constructor' do
    it 'accepts attribute hash' do
      instance = subject.new(:name => 'Jane')
      expect(instance.name).to eql('Jane')
    end
  end

  shared_examples_for 'a model with mass-assignment' do
    let(:attributes) do
      { :name => 'Jane', :something => nil }
    end

    before do
      instance.attributes = attributes
    end

    it 'accepts attribute hash' do
      expect(instance.attributes).to eql(attributes)
    end
  end

  shared_examples_for 'a model with strict mode turned off' do
    it 'has attributes with strict set to false' do
      expect(subject.send(:attribute_set)[:name]).to_not be_strict
    end
  end

  context 'with default configuration' do
    let(:mod) { Virtus.model }

    context 'with a class' do
      let(:model) { Class.new }

      subject { model }

      before do
        subject.send(:include, mod)
        subject.attribute :name, String, :default => 'Jane'
        subject.attribute :something
      end

      it_behaves_like 'a model with constructor'

      it_behaves_like 'a model with strict mode turned off'

      it_behaves_like 'a model with mass-assignment' do
        let(:instance) { subject.new }
      end

      it 'defaults to Object for attribute type' do
        expect(model.attribute_set[:something].type).to be(Axiom::Types::Object)
      end

      context 'with a sub-class' do
        subject { Class.new(model) }

        before do
          subject.attribute :age, Integer
        end

        it_behaves_like 'a model with constructor'

        it_behaves_like 'a model with strict mode turned off'

        it_behaves_like 'a model with mass-assignment' do
          let(:instance) { subject.new }

          let(:attributes) {
            { :name => 'Jane', :something => nil, :age => 23 }
          }
        end

        it 'has its own attributes' do
          expect(subject.attribute_set[:age]).to be_kind_of(Virtus::Attribute)
        end
      end
    end

    context 'with an instance' do
      subject { Class.new.new }

      before do
        subject.extend(mod)
        subject.attribute :name, String
        subject.attribute :something
      end

      it_behaves_like 'a model with strict mode turned off'

      it_behaves_like 'a model with mass-assignment' do
        let(:instance) { subject }
      end
    end
  end

  context 'when constructor is disabled' do
    subject { Class.new.send(:include, mod) }

    let(:mod) { Virtus.model(:constructor => false) }

    it 'does not accept attribute hash in the constructor' do
      expect { subject.new({}) }.to raise_error(ArgumentError)
    end
  end

  context 'when strict mode is enabled' do
    let(:mod)   { Virtus.model(:strict => true) }
    let(:model) { Class.new }

    context 'with a class' do
      subject { model.new }

      before do
        model.send(:include, mod)
        model.attribute :name, String
      end

      it 'has attributes with strict set to true' do
        expect(model.attribute_set[:name]).to be_strict
      end
    end

    context 'with an instance' do
      subject { model.new }

      before do
        subject.extend(mod)
        subject.attribute :name, String
      end

      it 'has attributes with strict set to true' do
        expect(subject.send(:attribute_set)[:name]).to be_strict
      end
    end
  end

  context 'when mass-assignment is disabled' do
    let(:mod)   { Virtus.model(:mass_assignment => false) }
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
