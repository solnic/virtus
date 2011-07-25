require 'spec_helper'

describe Virtus::Coercion::Date, '.to_datetime' do
  subject { object.to_datetime(date) }

  let(:object) { described_class      }
  let(:date)   { Date.new(2011, 1, 1) }

  context 'when Date does not support #to_datetime' do
    if RUBY_VERSION < '1.9'
      before do
        date.should_not respond_to(:to_datetime)
      end
    end

    it { should be_instance_of(DateTime) }

    it { should eql(DateTime.new(2011, 1, 1)) }
  end

  context 'when Date supports #to_datetime' do
    let(:datetime) { DateTime.new(2011, 1, 1) }

    before do
      date.stub!(:to_datetime).and_return(datetime)
    end

    it { should equal(datetime) }
  end
end
