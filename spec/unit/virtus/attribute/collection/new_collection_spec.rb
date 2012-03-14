require 'spec_helper'

describe Virtus::Attribute::Collection, '#new_collection' do
  subject { object.new_collection }

  let(:object) { Virtus::Attribute::Set.new('stuff') }

  it { should be_instance_of(Set) }
end
