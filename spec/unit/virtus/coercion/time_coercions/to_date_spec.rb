require 'spec_helper'

describe Virtus::Coercion::TimeCoercions, '.to_date' do
  subject { object.to_date(value) }

  let(:object) { Class.new(Virtus::Coercion::Object) }
  let(:value)  { mock('value')                       }

  context 'when the value responds to #to_date' do
    before do
      object.extend Virtus::Coercion::TimeCoercions

      value.should_receive(:to_date).and_return(Date.new(2011, 1, 1))
    end

    it { should be_instance_of(Date) }

    it { should eql(Date.new(2011, 1, 1)) }
  end

  context 'when the value does not respond to #to_date' do
    before do
      object.extend Virtus::Coercion::TimeCoercions

      # use a string that Date.parse can handle
      value.should_receive(:to_s).and_return('2011-01-01')
    end

    it { should be_instance_of(Date) }

    it { should eql(Date.new(2011, 1, 1)) }
  end
end
