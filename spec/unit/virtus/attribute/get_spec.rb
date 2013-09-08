require 'spec_helper'

describe Virtus::Attribute, '#get' do
  subject { object.get(instance) }

  let(:object) { described_class.build(:name, String) }

  let(:model)    { Class.new { attr_writer :name } }
  let(:instance) { model.new }
  let(:value)    { 'Jane Doe' }

  before do
    instance.name = value
  end

  it { should be(value) }
end
