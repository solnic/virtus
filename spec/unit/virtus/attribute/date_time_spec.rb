require 'spec_helper'

describe Virtus::Attribute::DateTime do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :created_at }
    let(:attribute_value)       { DateTime.now }
    let(:attribute_value_other) { DateTime.now.to_s }
  end

  describe '#typecast' do
    let(:model)     { Class.new { include Virtus } }
    let(:attribute) { model.attribute(:bday, Virtus::Attribute::DateTime) }

    let(:year)  { 2011 }
    let(:month) { 4 }
    let(:day)   { 7 }
    let(:hour)  { 1 }
    let(:min)   { 26 }
    let(:sec)   { 49 }

    subject { attribute.typecast(value) }

    shared_examples_for "a correct date time" do
      it          { should be_kind_of(DateTime) }
      its(:year)  { should eql(year)  }
      its(:month) { should eql(month) }
      its(:day)   { should eql(day)   }
      its(:hour)  { should eql(hour)  }
      its(:min)   { should eql(min)   }
      its(:sec)   { should eql(sec)   }
    end

    context 'with a hash' do
      it_should_behave_like "a correct date time" do
        let(:value) do
          { :year => year, :month => month, :day => day,
            :hour => hour, :min   => min,   :sec => sec }
        end
      end
    end

    context 'with a string' do
      context "without hour, min and sec" do
        let(:hour) { 0 }
        let(:min)  { 0 }
        let(:sec)  { 0 }

        it_should_behave_like "a correct date time" do
          let(:value) { "April #{day}th, #{year}" }
        end
      end

      context "with hour, min and sec" do
        it_should_behave_like "a correct date time" do
          let(:value) { "April #{day}th, #{year}, #{hour}:#{min}:#{sec}" }
        end
      end
    end

    context 'with a on-date value' do
      let(:value) { 'non-date' }
      it { should equal(value) }
    end
  end
end
