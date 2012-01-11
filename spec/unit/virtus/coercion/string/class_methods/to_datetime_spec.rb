require 'spec_helper'

shared_examples_for 'a correct datetime object' do
  it { should be_instance_of(DateTime) }

  its(:year)  { should == year  }
  its(:month) { should == month }
  its(:day)   { should == day   }
  its(:hour)  { should == hour  }
  its(:min)   { should == min   }
  its(:sec)   { should == sec   }
end

describe Virtus::Coercion::String, '.to_datetime' do
  subject { object.to_datetime(string) }

  let(:object) { described_class }

  context 'with a valid date string' do
    let(:year)  { 2011 }
    let(:month) { 7    }
    let(:day)   { 22   }

    context 'not including time part' do
      let(:string) { "July, #{day}th, #{year}" }

      let(:hour) { 0 }
      let(:min)  { 0 }
      let(:sec)  { 0 }

      it_should_behave_like 'a correct datetime object'
    end

    context 'including time part' do
      let(:string) { "July, #{day}, #{year}, #{hour}:#{min}:#{sec}" }

      let(:hour) { 13 }
      let(:min)  { 44 }
      let(:sec)  { 50 }

      it_should_behave_like 'a correct datetime object'
    end
  end

  context 'with an invalid date time string' do
    let(:string) { 'non-datetime' }

    it { should equal(string) }
  end
end
