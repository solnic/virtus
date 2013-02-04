require 'spec_helper'

describe Virtus::Attribute::Writer, '#call' do
  let(:object)   { described_class.new(:title) }
  let(:instance) { Class.new { attr_reader :title }.new }
  let(:value)    { 'test' }

  before do
    object.call(instance, value)
  end

  it 'sets attribute value' do
    expect(instance.title).to eql(value)
  end
end
