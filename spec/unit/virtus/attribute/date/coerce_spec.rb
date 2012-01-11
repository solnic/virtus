require 'spec_helper'

shared_examples_for 'a correct date' do
  it          { should be_kind_of(Date) }
  its(:year)  { should eql(year)        }
  its(:month) { should eql(month)       }
  its(:day)   { should eql(day)         }
end

describe Virtus::Attribute::Date, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute) { described_class.new(:bday) }
  let(:year)      { 2011                       }
  let(:month)     { 4                          }
  let(:day)       { 7                          }

  context 'with a time' do
    let(:value) { Time.local(year, month, day) }

    it_should_behave_like 'a correct date'
  end

  context 'with a date time' do
    let(:value) { DateTime.new(year, month, day) }

    it_should_behave_like 'a correct date'
  end

  context 'with a hash' do
    let(:value) { { :year => year, :month => month, :day => day } }

    it_should_behave_like 'a correct date'
  end

  context 'with a string' do
    let(:value) { "April #{day}th, #{year}" }

    it_should_behave_like 'a correct date'
  end

  context 'with a non-date value' do
    let(:value) { 'non-date' }

    it { should equal(value) }
  end
end
