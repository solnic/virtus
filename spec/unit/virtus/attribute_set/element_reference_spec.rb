require 'spec_helper'

describe Virtus::AttributeSet, '#[]' do
  subject { object[name] }

  let(:name)       { :name                                   }
  let(:attribute)  { Virtus::Attribute.build(String, :name => :name) }
  let(:attributes) { [ attribute ]                           }
  let(:parent)     { described_class.new                     }
  let(:object)     { described_class.new(parent, attributes) }

  it { is_expected.to equal(attribute) }

  it 'allows indexed access to attributes by the string representation of their name' do
    expect(object[name.to_s]).to equal(attribute)
  end
end
