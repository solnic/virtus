require 'spec_helper'

describe Virtus, '.module' do
  shared_examples_for 'a valid virtus object' do
    it 'reads and writes attribute' do
      instance.name = 'John'
      expect(instance.name).to eql('John')
    end
  end

  shared_examples_for 'an object extended with virtus module' do
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

  context 'as a peer to another module within a class' do
    subject { Virtus.module }
    let(:other)  { Module.new }

    before do
      other.send(:include, Virtus.module)
      other.attribute :last_name, String, :default => 'Doe'
      other.attribute :something_else
      model.send(:include, mod)
      model.send(:include, other)
    end

    it 'provides attributes for the model from both modules' do
      expect(model.attribute_set[:name]).to be_kind_of(Virtus::Attribute)
      expect(model.attribute_set[:something]).to be_kind_of(Virtus::Attribute)
      expect(model.attribute_set[:last_name]).to be_kind_of(Virtus::Attribute)
      expect(model.attribute_set[:something_else]).to be_kind_of(Virtus::Attribute)
    end

    it 'includes the attributes from both modules' do
      expect(model.new.attributes.keys).to eq(
        [:name, :something, :last_name, :something_else]
      )
    end
  end

  context 'with multiple other modules mixed into it' do
    subject { Virtus.module }
    let(:other)  { Module.new }
    let(:yet_another)  { Module.new }

    before do
      other.send(:include, Virtus.module)
      other.attribute :last_name, String, :default => 'Doe'
      other.attribute :something_else
      yet_another.send(:include, Virtus.module)
      yet_another.send(:include, mod)
      yet_another.send(:include, other)
      yet_another.attribute :middle_name, String, :default => 'Foobar'
      model.send(:include, yet_another)
    end

    it 'provides attributes for the model from all modules' do
      expect(model.attribute_set[:name]).to be_kind_of(Virtus::Attribute)
      expect(model.attribute_set[:something]).to be_kind_of(Virtus::Attribute)
      expect(model.attribute_set[:last_name]).to be_kind_of(Virtus::Attribute)
      expect(model.attribute_set[:something_else]).to be_kind_of(Virtus::Attribute)
      expect(model.attribute_set[:middle_name]).to be_kind_of(Virtus::Attribute)
    end

    it 'includes the attributes from all modules' do
      expect(model.new.attributes.keys).to eq(
        [:name, :something, :last_name, :something_else, :middle_name]
      )
    end
  end

end
