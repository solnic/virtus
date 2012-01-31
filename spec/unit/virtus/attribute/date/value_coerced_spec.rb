require 'spec_helper'

describe Virtus::Attribute::Date, '#value_coerced?' do
  subject { attribute.value_coerced?(value) }

  let(:attribute) { described_class.new(:bday) }
  let(:year)      { 2011                       }
  let(:month)     { 4                          }
  let(:day)       { 7                          }

  context 'with a Date' do
    let(:value) { Date.new(year, month, day) }

    it { should be(true) }
  end

  context 'with a date time' do
    let(:value) { DateTime.new(year, month, day) }

    it { should be(true) }
  end

  context 'with a time' do
    let(:value) { Time.local(year, month, day) }

    it { should be(false) }
  end

  context 'with a hash' do
    let(:value) { { :year => year, :month => month, :day => day } }

    it { should be(false) }
  end

  context 'with a string' do
    let(:value) { "April #{day}th, #{year}" }

    it { should be(false) }
  end

  context 'with a non-date value' do
    let(:value) { 'non-date' }

    it { should be(false) }
  end
end
