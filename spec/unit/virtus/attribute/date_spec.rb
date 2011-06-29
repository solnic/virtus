require 'spec_helper'

describe Virtus::Attribute::Date do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :created_on }
    let(:attribute_value)       { Date.today }
    let(:attribute_value_other) { (Date.today+1).to_s }
  end

  describe '#typecast' do
    let(:attribute) { Virtus::Attribute::Date.new(:bday) }

    let(:year)  { 2011 }
    let(:month) { 4 }
    let(:day)   { 7 }

    subject { attribute.typecast(value) }

    shared_examples_for "a correct date" do
      it          { should be_kind_of(Date) }
      its(:year)  { should eql(year)  }
      its(:month) { should eql(month) }
      its(:day)   { should eql(day)   }
    end

    context 'with a time' do
      it_should_behave_like "a correct date" do
        let(:value) { Time.local(year, month, day) }
      end
    end

    context 'with a date time' do
      it_should_behave_like "a correct date" do
        let(:value) { DateTime.new(year, month, day) }
      end
    end

    context 'with a hash' do
      it_should_behave_like "a correct date" do
        let(:value) do
          { :year => year, :month => month, :day => day }
        end
      end
    end

    context 'with a string' do
      it_should_behave_like "a correct date" do
        let(:value) { "April #{day}th, #{year}" }
      end
    end

    context 'with a non-date value' do
      let(:value) { 'non-date' }
      it { should equal(value) }
    end
  end
end
