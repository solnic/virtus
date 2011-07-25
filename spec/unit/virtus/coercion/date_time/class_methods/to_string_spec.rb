require 'spec_helper'

describe Virtus::Coercion::DateTime, '.to_string' do
  subject { object.to_string(date_time) }

  let(:object)    { described_class                      }
  let(:date_time) { DateTime.new(2011, 1, 1, 0, 0, 0, 0) }

  it { should be_instance_of(String) }

  it { should eql('2011-01-01T00:00:00+00:00') }
end
