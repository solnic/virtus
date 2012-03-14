require 'spec_helper'

describe Virtus::Attribute::Collection, '#member_type' do
  subject { object.member_type }

  let(:object) { Virtus::Attribute::Set.new('stuff', :member_type => Integer) }

  it { should be(Integer) }
end
