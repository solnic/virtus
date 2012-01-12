require 'spec_helper'

describe Virtus::Coercion::Hash, '.to_date' do
  subject { object.to_date(hash) }

  let(:object) { described_class }

  context 'when time segments are missing' do
    let(:time_now) { Time.local(2011, 1, 1) }
    let(:hash)     { {}                     }

    before do
      Time.stub!(:now).and_return(time_now)  # freeze time
    end

    it { should be_instance_of(Date) }

    it 'uses the Time now to populate the segments' do
      should eql(Date.new(2011, 1, 1))
    end
  end

  context 'when time segments are integers' do
    let(:hash) { { :year => 2011, :month => 1, :day => 1 } }

    it { should be_instance_of(Date) }

    it { should eql(Date.new(2011, 1, 1)) }
  end

  context 'when time segments are strings' do
    let(:hash) { { :year => '2011', :month => '1', :day => '1' } }

    it { should be_instance_of(Date) }

    it { should eql(Date.new(2011, 1, 1)) }
  end
end
