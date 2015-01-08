require 'spec_helper'

describe Virtus::Attribute, '#present?' do
  subject { object.present?(instance) }

  let(:model)    { Class.new { attr_accessor :test } }
  let(:name)     { :test }
  let(:instance) { model.new }

  context 'when the attribute allows nil values' do
    let(:object) { described_class.build(String, :name => name, :allow_nil => true) }

    context 'and the attribute value is defined as nil' do
      before { instance.test = nil }
      it { should be(true) }
    end

    context 'and the attribute value is NOT defined' do
      it { should be(false) }
    end
  end

  context 'when the attribute does NOT allow nil values' do
    let(:object) { described_class.build(String, :name => name, :allow_nil => false) }

    context 'and the attribute value is defined' do
      before { instance.test = 'foo' }
      it { should be(true) }
    end

    context 'and the attribute value is defined as nil' do
      before { instance.test = nil }
      it { should be(false) }
    end

    context 'and the attribute value is NOT defined' do
      it { should be(false) }
    end
  end
end
