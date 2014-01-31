require 'spec_helper'

describe Virtus::Attribute, '#defined?' do
  subject { object.defined?(instance) }

  let(:object) { described_class.build(String, :name => name) }

  let(:model)    { Class.new { attr_accessor :test } }
  let(:name)     { :test }
  let(:instance) { model.new }

  context 'when the attribute value has not been defined' do
    it { should be(false) }
  end

  context 'when the attribute value has been defined' do
    before { instance.test = nil }
    it { should be(true) }
  end
end
