require 'spec_helper'

describe Character::Attributes::Date do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :created_on }
  end

  describe '#typecast' do
    let(:model)     { Class.new { include Character } }
    let(:attribute) { model.attribute(:bday, Character::Attributes::Date) }

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
