require 'spec_helper'

describe Virtus, '.module' do
  share_examples_for 'a valid virtus object' do
    it 'reads and writes attribute' do
      instance.name = 'Jane'
      expect(instance.name).to eql('Jane')
    end
  end

  share_examples_for 'an object extended with virtus module' do
    context 'with default configuration' do
      subject { Virtus.module }

      it_behaves_like 'a valid virtus object' do
        let(:instance) { model.new }
      end
    end

    context 'with constructor turned off' do
      subject { Virtus.module { |c| c.constructor = false } }

      it_behaves_like 'a valid virtus object' do
        let(:instance) { model.new }
      end

      it 'skips including constructor' do
        expect { model.new({}) }.to raise_error(ArgumentError)
      end
    end

    context 'with mass assignment is turned off' do
      subject { Virtus.module { |c| c.mass_assignment = false } }

      it_behaves_like 'a valid virtus object'

      it 'skips including mass assignment' do
        expect(instance).not_to respond_to(:attributes)
        expect(instance).not_to respond_to(:attributes=)
      end
    end
  end

  let(:mod)      { Module.new }
  let(:model)    { Class.new }
  let(:instance) { model.new }

  before do
    mod.send(:include, subject)
    mod.attribute :name, String
  end

  context 'with a class' do
    before do
      model.send(:include, mod)
    end

    it 'provides attributes for the model' do
      expect(model.attribute_set[:name]).to be_kind_of(Virtus::Attribute)
    end

    it_behaves_like 'an object extended with virtus module'
  end

  context 'with a model instance' do
    before do
      instance.extend(mod)
    end

    it 'provides attributes for the instance' do
      expect(instance.send(:attribute_set)[:name]).to be_kind_of(Virtus::Attribute)
    end

    it_behaves_like 'an object extended with virtus module'
  end
end
