require 'spec_helper'

describe Virtus, '.module' do
  share_examples_for 'a valid virtus object' do
    it 'reads and writes attribute' do
      instance.name = 'John'
      expect(instance.name).to eql('John')
    end
  end

  share_examples_for 'an object extended with virtus module' do
    context 'with default configuration' do
      subject { Virtus.module }

      it_behaves_like 'a valid virtus object' do
        let(:instance) { model.new }
      end

      it 'sets defaults' do
        expect(instance.name).to eql('Jane')
      end
    end

    context 'with constructor turned off' do
      subject { Virtus.module(:constructor => false) }

      it_behaves_like 'a valid virtus object' do
        let(:instance) { model.new }
      end

      it 'skips including constructor' do
        expect { model.new({}) }.to raise_error(ArgumentError)
      end
    end

    context 'with mass assignment is turned off' do
      subject { Virtus.module(:mass_assignment => false) }

      it_behaves_like 'a valid virtus object'

      it 'skips including mass assignment' do
        expect(instance).not_to respond_to(:attributes)
        expect(instance).not_to respond_to(:attributes=)
      end
    end

    context 'with coercion turned off' do
      subject { Virtus.module(:coerce => false) }

      it_behaves_like 'a valid virtus object'

      it 'builds non-coercible attributes' do
        expect(object.send(:attribute_set)[:name]).not_to be_coercible
      end
    end
  end

  let(:mod)      { Module.new }
  let(:model)    { Class.new }
  let(:instance) { model.new }

  before do
    mod.send(:include, subject)
    mod.attribute :name, String, :default => 'Jane'
    mod.attribute :something
  end

  context 'with a class' do
    let(:object) { model }

    before do
      model.send(:include, mod)
    end

    it 'provides attributes for the model' do
      expect(model.attribute_set[:name]).to be_kind_of(Virtus::Attribute)
    end

    it 'defaults to Object for attribute type' do
      expect(model.attribute_set[:something].type).to be(Axiom::Types::Object)
    end

    it_behaves_like 'an object extended with virtus module'
  end

  context 'with a model instance' do
    let(:object) { instance }

    before do
      instance.extend(mod)
    end

    it 'provides attributes for the instance' do
      expect(instance.send(:attribute_set)[:name]).to be_kind_of(Virtus::Attribute)
    end

    it_behaves_like 'an object extended with virtus module'
  end

  context 'with another module' do
    let(:other)  { Module.new }

    let(:object) { instance }

    before do
      other.send(:include, mod)
      model.send(:include, other)
    end

    it_behaves_like 'an object extended with virtus module'

    it 'provides attributes for the model' do
      expect(model.attribute_set[:name]).to be_kind_of(Virtus::Attribute)
    end
  end

end
