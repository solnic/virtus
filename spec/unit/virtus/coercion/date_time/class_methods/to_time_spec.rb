require 'spec_helper'

describe Virtus::Coercion::DateTime, '.to_time' do
  subject { object.to_time(date_time) }

  let(:object)    { described_class          }
  let(:date_time) { DateTime.new(2011, 1, 1) }

  context 'when DateTime does not support #to_time' do
    if RUBY_VERSION < '1.9'
      before do
        date_time.should_not respond_to(:to_time)
      end
    end

    it { should be_instance_of(Time) }

    it { should eql(Time.local(2011, 1, 1)) }
  end

  context 'when DateTime supports #to_time' do
    let(:time) { Time.local(2011, 1, 1) }

    before do
      date_time.stub!(:to_time).and_return(time)
    end

    it { should equal(time) }
  end
end
