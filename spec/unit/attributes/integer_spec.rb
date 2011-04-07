require 'spec_helper'

describe Character::Attributes::Integer do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :age }
  end

  describe '#typecast' do
    let(:model)     { Class.new { include Character } }
    let(:attribute) { model.attribute(:age, Character::Attributes::Integer) }

    subject { attribute.typecast(value) }

    context "with an integer" do
      let(:value) { 24 }
      it { should == value }
    end

    context 'with a zero string integer' do
      let(:value) { 24 }
      it { should == value }
    end

    context 'with a positive string integer' do
      let(:value) { '24' }
      it { should == 24 }
    end

    context 'with a negative string integer' do
      let(:value) { '-24' }
      it { should == -24 }
    end

    context 'with a zero string float' do
      let(:value) { 0.0 }
      it { should == 0 }
    end

    context 'with a positive string float' do
      let(:value) { '24.35' }
      it { should == 24 }
    end

    context 'with a negative string float' do
      let(:value) { '-24.35' }
      it { should == -24 }
    end

    context 'with a zero string float, with no leading digits' do
      let(:value) { '.0' }
      it { should == 0 }
    end

    context 'with a positive string float, with no leading digits' do
      let(:value) { '.41' }
      it { should == 0 }
    end

    context 'with a zero float' do
      let(:value) { 0.0 }
      it { should == 0 }
    end

    context 'with a positive float' do
      let(:value) { 24.35 }
      it { should == 24 }
    end

    context 'with a negative float' do
      let(:value) { -24.35 }
      it { should == -24 }
    end

    context 'with a zero decimal' do
      let(:value) { BigDecimal('0.0') }
      it { should == 0 }
    end

    context 'with a positive decimal' do
      let(:value) { BigDecimal('24.35') }
      it { should == 24 }
    end

    context 'with a negative decimal' do
      let(:value) { BigDecimal('-24.35') }
      it { should == -24 }
    end

    [ Object.new, true, '00.0', '0.', '-.0', 'string' ].each do |non_num_value|
      context "does not typecast non-numeric value #{non_num_value.inspect}" do
        let(:value) { non_num_value }
        it { should == non_num_value }
      end
    end
  end
end
