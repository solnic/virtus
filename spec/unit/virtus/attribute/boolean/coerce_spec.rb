require 'spec_helper'

describe Virtus::Attribute::Boolean, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute) { described_class.new(:is_admin) }

  context 'with 1' do
    let(:value) { 1 }

    it { should be(true) }
  end

  context 'with "1"' do
    let(:value) { '1' }

    it { should be(true) }
  end

  context 'with "true"' do
    let(:value) { 'true' }

    it { should be(true) }
  end

  context 'with "TRUE"' do
    let(:value) { 'TRUE' }

    it { should be(true) }
  end

  context 'with "t"' do
    let(:value) { 't' }

    it { should be(true) }
  end

  context 'with "T"' do
    let(:value) { 'T' }

    it { should be(true) }
  end

  context 'with 0' do
    let(:value) { 0 }

    it { should be(false) }
  end

  context 'with "0"' do
    let(:value) { '0' }

    it { should be(false) }
  end

  context 'with "false"' do
    let(:value) { 'false' }

    it { should be(false) }
  end

  context 'with "FALSE"' do
    let(:value) { 'FALSE' }

    it { should be(false) }
  end

  context 'with "f"' do
    let(:value) { 'f' }

    it { should be(false) }
  end

  context 'with "F"' do
    let(:value) { 'F' }

    it { should be(false) }
  end

  context 'with "Foo"' do
    let(:value) { 'Foo' }

    it { should equal(value) }
  end
end
