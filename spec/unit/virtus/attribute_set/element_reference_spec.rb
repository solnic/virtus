require 'spec_helper'

describe Virtus::AttributeSet, '#[]' do
  subject { object[name] }

  let(:name)       { :name                                   }
  let(:attribute)  { mock('Attribute', :name => name)        }
  let(:attributes) { [ attribute ]                           }
  let(:parent)     { described_class.new                     }
  let(:object)     { described_class.new(attributes, parent) }

  it { should equal(attribute) }
end
