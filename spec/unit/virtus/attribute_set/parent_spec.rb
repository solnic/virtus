require 'spec_helper'

describe Virtus::AttributeSet, '#parent' do
  subject { object.parent }

  let(:attributes) { []                                      }
  let(:parent)     { described_class.new                     }
  let(:object)     { described_class.new(attributes, parent) }

  it { should equal(parent) }
end
