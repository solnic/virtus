require 'spec_helper'

shared_examples_for 'a correct date time' do
  it { should be_kind_of(DateTime) }

  its(:year)  { should eql(year)  }
  its(:month) { should eql(month) }
  its(:day)   { should eql(day)   }
  its(:hour)  { should eql(hour)  }
  its(:min)   { should eql(min)   }
  its(:sec)   { should eql(sec)   }
end

describe Virtus::Attribute::DateTime, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute) { described_class.new(:bday) }
  let(:year)      { 2011                       }
  let(:month)     { 4                          }
  let(:day)       { 7                          }
  let(:hour)      { 1                          }
  let(:min)       { 26                         }
  let(:sec)       { 49                         }

  context 'with a date' do
    let(:hour)  { 0                          }
    let(:min)   { 0                          }
    let(:sec)   { 0                          }
    let(:value) { Date.new(year, month, day) }

    it_should_behave_like 'a correct date time'
  end

  context 'with a time' do
    let(:value) { Time.local(year, month, day, hour, min, sec) }

    it_should_behave_like 'a correct date time'
  end

  context 'with a hash' do
    let(:value) { { :year => year, :month => month, :day => day, :hour => hour, :min => min, :sec => sec } }

    it_should_behave_like 'a correct date time'
  end

  context 'with a string' do
    context 'without hour, min and sec' do
      let(:hour)  { 0                         }
      let(:min)   { 0                         }
      let(:sec)   { 0                         }
      let(:value) { "April #{day}th, #{year}" }

      it_should_behave_like 'a correct date time'
    end

    context 'with hour, min and sec' do
      let(:value) { "April #{day}th, #{year}, #{hour}:#{min}:#{sec}" }

      it_should_behave_like 'a correct date time'
    end
  end

  context 'with an integer with the seconds since the Unix Epoch' do
    let(:value) { 1302139609 }

    it_should_behave_like 'a correct date time'
  end

  context 'with a float with the seconds and milliseconds since the Unix Epoch' do
    let(:value) { 1302139609.664 }

    it_should_behave_like 'a correct date time'
  end

  context 'with a on-date value' do
    let(:value) { 'non-date' }

    it { should equal(value) }
  end
end
