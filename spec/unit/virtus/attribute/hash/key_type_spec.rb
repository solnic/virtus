require 'spec_helper'

describe Virtus::Attribute::Hash, '#key_type' do
  subject { object.key_type }

  let(:object)   { Virtus::Attribute.build(:meta, Hash[key_type => String]) }
  let(:key_type) { Symbol }

  it { should be(key_type) }
end
