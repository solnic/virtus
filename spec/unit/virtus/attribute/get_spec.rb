require 'spec_helper'

describe Virtus::Attribute, '#get' do
  subject { object.get(instance) }

  let(:object) { described_class.build(String, options.update(:name => name)) }

  let(:model)    { Class.new { attr_accessor :test } }
  let(:name)     { :test }
  let(:instance) { model.new }
  let(:value)    { 'Jane Doe' }
  let(:options)  { {} }

  context 'with :lazy is set to false' do
    before do
      instance.test = value
    end

    it { is_expected.to be(value) }
  end

  context 'with :lazy is set to true' do
    let(:options) { { :lazy => true, :default => value } }

    it { is_expected.to eql(value) }

    it 'sets default only on first access' do
      expect(object.get(instance)).to eql(value)
      expect(object.get(instance)).to be(instance.test)
    end
  end
end
