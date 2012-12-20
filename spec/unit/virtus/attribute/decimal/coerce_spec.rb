require 'spec_helper'

describe Virtus::Attribute::Decimal, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute) { described_class.new(:price) }

  context 'with 24.0 big decimal' do
    let(:value) { BigDecimal('24.0') }

    it { should eql(value) }
  end

  context 'with a zero string integer' do
    let(:value) { '0' }

    it { should eql(BigDecimal('0.0')) }
  end

  context 'with a positive string integer' do
    let(:value) { '24' }

    it { should eql(BigDecimal('24.0')) }
  end

  context 'with a negative string integer' do
    let(:value) { '-24' }

    it { should eql(BigDecimal('-24.0')) }
  end

  context 'with a zero string float' do
    let(:value) { '0.0' }

    it { should eql(BigDecimal('0.0')) }
  end

  context 'with a positive string float' do
    let(:value) { '24.35' }

    it { should eql(BigDecimal('24.35')) }
  end

  context 'with a negative string float' do
    let(:value) { '-24.35' }

    it { should eql(BigDecimal('-24.35')) }
  end

  context 'with a zero string float, with no leading digits' do
    let(:value) { '.0' }

    it { should eql(BigDecimal('0.0')) }
  end

  context 'with a positive string float, with no leading digits' do
    let(:value) { '0.41' }

    it { should eql(BigDecimal('0.41')) }
  end

  context 'with a positive string float and leading non-significant digits' do
    let (:value) { '00.0' }

    it { should eql(BigDecimal('0.0')) }
  end

  context 'with a zero integer' do
    let(:value) { 0 }

    it { should eql(BigDecimal('0.0')) }
  end

  context 'with a positive integer' do
    let(:value) { 24 }

    it { should eql(BigDecimal('24.0')) }
  end

  context 'with a negative integer' do
    let(:value) { -24 }

    it { should eql(BigDecimal('-24.0')) }
  end

  context 'with a positive bignum' do
    let(:value) { 1311936052 }

    it { should eql(BigDecimal('1311936052.0')) }
  end

  context 'with a negative bignum' do
    let(:value) { -1311936052 }

    it { should eql(BigDecimal('-1311936052.0')) }
  end

  context 'with a zero float' do
    let(:value) { 0.0 }

    it { should eql(BigDecimal('0.0')) }
  end

  context 'with a positive float' do
    let(:value) { 24.35 }

    it { should eql(BigDecimal('24.35')) }
  end

  context 'with a negative float' do
    let(:value) { -24.35 }

    it { should eql(BigDecimal('-24.35')) }
  end

  [ Object.new, true, '0.', '-.0', 'string' ].each do |non_num_value|
    context 'with a non-numeric value = #{non_num_value.inspect}' do
      let(:value) { non_num_value }

      it { should equal(non_num_value) }
    end
  end
end
