require 'spec_helper'

describe Virtus::Attribute::Hash, '#value_type' do
  subject { object.value_type }

  let(:object)     { Virtus::Attribute.build(:meta, Hash[Symbol => value_type]) }
  let(:value_type) { String }

  it { should be(value_type) }
end
