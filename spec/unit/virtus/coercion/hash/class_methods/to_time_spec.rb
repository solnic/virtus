require 'spec_helper'

describe Virtus::Coercion::Hash, '.to_time' do
  subject { object.to_time(hash) }

  let(:object) { described_class }

  context 'when time segments are missing' do
    let(:time_now) { Time.local(2011, 1, 1) }
    let(:hash)     { {}                     }

    before do
      Time.stub!(:now).and_return(time_now)  # freeze time
    end

    it { should be_instance_of(Time) }

    it 'uses the Time now to populate the segments' do
      should eql(time_now)
    end
  end

  context 'when time segments are integers' do
    let(:hash) { { :year => 2011, :month => 1, :day => 1, :hour => 1, :min => 1, :sec => 1 } }

    it { should be_instance_of(Time) }

    it { should eql(Time.local(2011, 1, 1, 1, 1, 1)) }
  end

  context 'when time segments are strings' do
    let(:hash) { { :year => '2011', :month => '1', :day => '1', :hour => '1', :min => '1', :sec => '1' } }

    it { should be_instance_of(Time) }

    it { should eql(Time.local(2011, 1, 1, 1, 1, 1)) }
  end
end
