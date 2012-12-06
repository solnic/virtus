require 'spec_helper'

describe Virtus::Extensions, '#attribute' do
  subject { object.attribute(name, type) }

  let(:object)     { Class.new { extend Virtus::Extensions } }
  let(:descendant) { Class.new(object)                       }
  let(:name)       { :name                                   }
  let(:type)       { Virtus::Attribute::String               }

  def assert_attribute_added(klass, name, attribute_class)
    klass.should_not be_public_method_defined(name)
    subject
    klass.should_not be_public_method_defined(name)
  end

  it { should be(object) }

  it 'adds the attribute to the class' do
    assert_attribute_added(object, name, type)
  end

  it 'adds the attribute to the descendant' do
    assert_attribute_added(descendant, name, type)
  end
end
