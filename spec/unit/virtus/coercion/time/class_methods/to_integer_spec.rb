require 'spec_helper'

describe Virtus::Coercion::Time, '.to_integer' do
  subject { described_class.to_integer(value) }

  let(:time)  { Time.now }
  let(:value) { time     }

  it { should eql(time.to_i) }
end
