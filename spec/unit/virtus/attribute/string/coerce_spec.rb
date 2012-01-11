require 'spec_helper'

describe Virtus::Attribute::String, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute)    { described_class.new(:name) }
  let(:value)        { 1                          }
  let(:coerce_value) { '1'                        }

  it { should eql(coerce_value) }
end
