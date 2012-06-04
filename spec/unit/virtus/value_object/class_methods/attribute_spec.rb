require 'spec_helper'

describe Virtus::ValueObject, '.attribute' do
  subject { object.attribute(name, type) }

  let(:object)    { Class.new { include Virtus::ValueObject } }
  let(:name)      { :latitude                                 }
  let(:type)      { Float                                     }
  let(:attribute) { object.attribute_set[name]                }

  it { should be(object) }

  it 'adds the attribute to the equalizer' do
    object.new.inspect.should_not match(/\b#{name}=\b/)
    subject
    object.new.inspect.should match(/\b#{name}=\b/)
  end

  it 'sets the writer to be private' do
    subject
    attribute.options[:writer].should be(:private)
  end
end
