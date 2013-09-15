require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '#coerce' do
  subject { object.coerce(input) }

  let(:model)  { OpenStruct }
  let(:object) { described_class.build(model) }

  context 'when input is an attribute hash' do
    let(:input) { Hash[name: 'Piotr', age: 30] }

    it { should be_instance_of(model) }

    its(:name) { should eql('Piotr') }
    its(:age)  { should eql(30) }
  end

  context 'when input is nil' do
    let(:input) { nil }

    it { should be(nil) }
  end

  context 'when input is a model instance' do
    let(:input) { OpenStruct.new }

    it { should be(input) }
  end
end
