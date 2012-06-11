require 'spec_helper'

describe Virtus::ModuleExtensions, '#attribute' do
  subject { object.attribute(name, type, options) }

  let(:object)  { Module.new              }
  let(:name)    { :name                   }
  let(:type)    { String                  }
  let(:options) { { :default => default } }
  let(:default) { 'John Doe'.freeze       }

  before do
    object.extend(Virtus::ModuleExtensions)
  end

  it { should be(object) }

  it 'tracks the attribute for extension' do
    subject
    instance = Object.new
    instance.extend(object)
    instance.attributes[name].should eql(default)
  end

  it 'tracks the attribute for inclusion' do
    subject
    klass = Class.new
    klass.send(:include, object)
    klass.attribute_set[name].should eql(Virtus::Attribute::String.new(name, options))
  end
end
