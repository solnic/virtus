require 'spec_helper'

shared_examples_for 'a correct time' do
  it          { should be_kind_of(Time) }
  its(:year)  { should eql(year)        }
  its(:month) { should eql(month)       }
  its(:day)   { should eql(day)         }
  its(:hour)  { should eql(hour)        }
  its(:min)   { should eql(min)         }
  its(:sec)   { should eql(sec)         }
end

describe Virtus::Attribute::Time, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute) { described_class.new(:bday) }
  let(:year)      { 1983                       }
  let(:month)     { 11                         }
  let(:day)       { 18                         }
  let(:hour)      { 8                          }
  let(:min)       { 16                         }
  let(:sec)       { 32                         }

  context 'with a date' do
    let(:hour)  { 0                                              }
    let(:min)   { 0                                              }
    let(:sec)   { 0                                              }
    let(:value) { DateTime.new(year, month, day, hour, min, sec) }

    it_should_behave_like 'a correct time'
  end

  context 'with a date time' do
    let(:value) { DateTime.new(year, month, day, hour, min, sec) }

    it_should_behave_like 'a correct time'
  end

  context 'with a hash' do
    let(:value) { { :year => year, :month => month, :day => day, :hour => hour, :min => min, :sec => sec } }

    it_should_behave_like 'a correct time'
  end

  context 'with a string' do
    context 'without hour, min and sec' do
      let(:hour)  { 0                            }
      let(:min)   { 0                            }
      let(:sec)   { 0                            }
      let(:value) { "November #{day}th, #{year}" }

      it_should_behave_like 'a correct time'
    end

    context 'with hour, min and sec' do
      let(:value) { "November #{day}th, #{year}, #{hour}:#{min}:#{sec}" }

      it_should_behave_like 'a correct time'
    end
  end

  context 'with a non-date value' do
    let(:value) { '2999' }

    it { should equal(value) }
  end
end
