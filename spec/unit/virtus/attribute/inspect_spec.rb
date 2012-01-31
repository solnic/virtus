require 'spec_helper'

describe Virtus::Attribute, '#inspect' do
  subject { object.inspect }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }

  context 'with a named attribute class' do
    let(:described_class) { NamedAttribute = Class.new(Virtus::Attribute) }

    after do
      klass = Object.class_eval { remove_const(:NamedAttribute) }
      Virtus::Attribute.descendants.delete(klass)
    end

    it { should eql("#<NamedAttribute @name=:name>") }
  end

  context 'with an anonymous attribute class' do
    let(:described_class) { Class.new(Virtus::Attribute) }

    it { should eql("#<#{described_class} @name=:name>") }
  end
end
