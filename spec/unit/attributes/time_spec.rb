require 'spec_helper'

describe Character::Attributes::Time do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :birthday }
  end

  describe '#typecast' do
    let(:model)     { Class.new { include Character } }
    let(:attribute) { model.attribute(:birthday, Character::Attributes::Time) }

    let(:year)  { 1983 }
    let(:month) { 11 }
    let(:day)   { 18 }
    let(:hour)  { 8 }
    let(:min)   { 16 }
    let(:sec)   { 32 }

    subject { attribute.typecast(value) }

    shared_examples_for "a correct time" do
      it          { should be_kind_of(Time) }
      its(:year)  { should == year  }
      its(:month) { should == month }
      its(:day)   { should == day   }
      its(:hour)  { should == hour   }
      its(:min)   { should == min   }
      its(:sec)   { should == sec   }
    end

    context 'with a hash' do
      it_should_behave_like "a correct time" do
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

        it_should_behave_like "a correct time" do
          let(:value) { "November #{day}th, #{year}" }
        end
      end

      context "with hour, min and sec" do
        it_should_behave_like "a correct time" do
          let(:value) { "November #{day}th, #{year}, #{hour}:#{min}:#{sec}" }
        end
      end
    end

    context 'with a non-date value' do
      let(:value) { 'non-date' }
      it { should == value }
    end
  end
end
