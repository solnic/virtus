require 'spec_helper'

describe Virtus::Coercion::Date, '.to_time' do
  subject { object.to_time(date) }

  let(:object) { described_class      }
  let(:date)   { Date.new(2011, 1, 1) }

  it { should be_instance_of(Time) }

  it { should eql(Time.local(2011, 1, 1)) }
end
