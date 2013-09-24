require 'spec_helper'

describe Virtus, '.module' do
  context 'with default configuration' do
    subject { Virtus.module }

    let(:model) { Class.new }
    let(:mod)   { Module.new }

    it 'creates a virtus module' do
      mod = Virtus.module

      mod.send(:include, subject)
      mod.attribute :name, String

      model.send(:include, mod)

      expect(model.attribute_set[:name]).to be_kind_of(Virtus::Attribute)
    end
  end
end
