require 'spec_helper'

describe Virtus::Attribute::DefaultValue, '#attribute' do
  subject { object.attribute }

  let(:object)    { described_class.new(attribute, value) }
  let(:attribute) { mock('attribute')                     }
  let(:value)     { mock('value')                         }

  it { should be(attribute) }
end
