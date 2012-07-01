require 'spec_helper'

describe Virtus::AttributeSet, '#inspect' do
  subject { object.inspect }

  let(:object) { described_class.new('Test') }

  it { pending; should eql('Test::AttributeSet') }
end
