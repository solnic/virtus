require 'spec_helper'

describe Virtus::Coercion::TimeCoercions, '.to_datetime' do
  subject { object.to_datetime(value) }

  let(:object) { Class.new(Virtus::Coercion::Object) }
  let(:value)  { mock('value')                       }

  context 'when the value responds to #to_datetime' do
    before do
      object.extend Virtus::Coercion::TimeCoercions

      value.should_receive(:to_datetime).and_return(DateTime.new(2011, 1, 1, 0, 0, 0))
    end

    it { should be_instance_of(DateTime) }

    it { should eql(DateTime.new(2011, 1, 1, 0, 0, 0)) }
  end

  context 'when the value does not respond to #to_datetime' do
    before do
      object.extend Virtus::Coercion::TimeCoercions

      # use a string that DateTime.parse can handle
      value.should_receive(:to_s).and_return('2011-01-01T00:00:00+00:00')
    end

    it { should be_instance_of(DateTime) }

    it { should eql(DateTime.new(2011, 1, 1, 0, 0, 0)) }
  end
end
