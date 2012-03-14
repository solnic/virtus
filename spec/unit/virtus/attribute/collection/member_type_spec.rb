require 'spec_helper'

describe Virtus::Attribute::Collection, '#member_type' do
  subject { object.member_type }

  context 'when specified' do
    let(:object) { Virtus::Attribute::Set.new('stuff', :member_type => Integer) }

    it { should be(Integer) }
  end

  context 'when not specified' do
    let(:object) { Virtus::Attribute::Set.new('stuff') }

    it { should be(Virtus::Attribute::Object) }
  end
end
