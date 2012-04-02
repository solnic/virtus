require 'spec_helper'

describe Virtus::Coercion::TimeCoercions, '.to_string' do
  subject { object.to_string(value) }

  let(:object) { Class.new(Virtus::Coercion::Object) }
  let(:value)  { mock('value')                       }

  before do
    object.extend Virtus::Coercion::TimeCoercions

    value.should_receive(:to_s).and_return('2011-01-01')
  end

  it { should be_instance_of(String) }

  it { should eql('2011-01-01') }
end
