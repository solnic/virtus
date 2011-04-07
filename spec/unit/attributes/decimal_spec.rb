require 'spec_helper'

describe Character::Attributes::Decimal do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :price }
    let(:attribute_value)       { BigDecimal("12.3456789") }
    let(:attribute_value_other) { "12.3456789" }
  end

  describe '#typecast' do
    let(:model)     { Class.new { include Character } }
    let(:attribute) { model.attribute(:price, Character::Attributes::Decimal) }

    subject { attribute.typecast(value) }

    context "with 24.0 big decimal" do
      let(:value) { BigDecimal('24.0') }
      it { should == value }
    end

    context 'with a zero string integer' do
      let(:value) { '0' }
      it { should == BigDecimal('0.0') }
    end

    context 'with a positive string integer' do
      let(:value) { '24' }
      it { should == BigDecimal('24.0') }
    end

    context 'with a negative string integer' do
      let(:value) { '-24' }
      it { should == BigDecimal('-24.0') }
    end

    context 'with a zero string float' do
      let(:value) { '0.0' }
      it { should == BigDecimal('0.0') }
    end

    context 'with a positive string float' do
      let(:value) { '24.35' }
      it { should == BigDecimal('24.35') }
    end

    context 'with a negative string float' do
      let(:value) { '-24.35' }
      it { should == BigDecimal('-24.35') }
    end

    context 'with a zero string float, with no leading digits' do
      let(:value) { '.0' }
      it { should == BigDecimal('0.0') }
    end

    context 'with a positive string float, with no leading digits' do
      let(:value) { '0.41' }
      it { should == BigDecimal('0.41') }
    end

    context 'with a zero integer' do
      let(:value) { 0 }
      it { should == BigDecimal('0.0') }
    end

    context 'with a positive integer' do
      let(:value) { 24 }
      it { should == BigDecimal('24.0') }
    end

    context 'with a negative integer' do
      let(:value) { -24 }
      it { should == BigDecimal('-24.0') }
    end

    context 'with a zero float' do
      let(:value) { 0.0 }
      it { should == BigDecimal('0.0') }
    end

    context 'with a positive float' do
      let(:value) { 24.35 }
      it { should == BigDecimal('24.35') }
    end

    context 'with a negative float' do
      let(:value) { -24.35 }
      it { should == BigDecimal('-24.35') }
    end

    [ Object.new, true, '00.0', '0.', '-.0', 'string' ].each do |non_num_value|
      context "with a non-numeric value = #{non_num_value.inspect}" do
        let(:value) { non_num_value }
        it { should == non_num_value }
      end
    end
  end
end
