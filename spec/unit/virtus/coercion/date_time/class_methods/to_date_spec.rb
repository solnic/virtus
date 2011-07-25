require 'spec_helper'

describe Virtus::Coercion::DateTime, '.to_date' do
  subject { object.to_date(date_time) }

  let(:object)    { described_class          }
  let(:date_time) { DateTime.new(2011, 1, 1) }

  context 'when DateTime does not support #to_date' do
    if RUBY_VERSION < '1.9'
      before do
        date_time.should_not respond_to(:to_date)
      end
    end

    it { should be_instance_of(Date) }

    it { should eql(Date.new(2011, 1, 1)) }
  end

  context 'when DateTime supports #to_date' do
    let(:date) { Date.new(2011, 1, 1) }

    before do
      date_time.stub!(:to_date).and_return(date)
    end

    it { should equal(date) }
  end
end
