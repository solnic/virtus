require 'spec_helper'

describe Virtus::Attributes::Date do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :created_on }
    let(:attribute_value)       { Date.today }
    let(:attribute_value_other) { (Date.today+1).to_s }
  end

  describe '#typecast' do
    let(:model)     { Class.new { include Virtus } }
    let(:attribute) { model.attribute(:bday, Virtus::Attributes::Date) }

    let(:year)  { 2011 }
    let(:month) { 4 }
    let(:day)   { 7 }

    subject { attribute.typecast(value) }

    shared_examples_for "a correct date" do
      it          { should be_kind_of(Date) }
      its(:year)  { should == year  }
      its(:month) { should == month }
      its(:day)   { should == day   }
    end

    context 'with a time' do
      it_should_behave_like "a correct date" do
        let(:value) { Time.local(year, month, day) }
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

    context 'with a on-date value' do
      let(:value) { 'non-date' }
      it { should == value }
    end
  end
end
