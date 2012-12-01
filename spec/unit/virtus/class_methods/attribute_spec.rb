require 'spec_helper'

describe Virtus::ClassMethods, '#attribute' do
  subject { object.attribute(name, type) }

  let(:object)     { Class.new { include Virtus } }
  let(:descendant) { Class.new(object)            }
  let(:name)       { :name                        }
  let(:type)       { Virtus::Attribute::String    }

  def assert_attribute_added(klass, name, attribute_class)
    attributes = klass.attribute_set
    attributes[name].should be_nil
    subject
    attribute = attributes[name]
    attribute.should_not be_nil
    attribute.name.should be(name)
    attribute.class.should be(attribute_class)
  end

  it { should be(object) }

  it 'adds the attribute to the class' do
    assert_attribute_added(object, name, type)
  end

  it 'adds the attribute to the descendant' do
    assert_attribute_added(descendant, name, type)
  end
end
