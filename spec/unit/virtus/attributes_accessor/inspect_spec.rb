require 'spec_helper'

describe Virtus::AttributesAccessor, '#inspect' do
  subject { object.inspect }

  let(:object) { described_class.new('Test') }

  it { should eql('Test::AttributesAccessor') }
end