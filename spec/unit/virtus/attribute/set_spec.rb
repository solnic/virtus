require 'spec_helper'

describe Virtus::Attribute, '#set' do
  subject { object.set(instance, value) }

  let(:object) { described_class.build(:name, String) }

  let(:model)    { Class.new { attr_reader :name } }
  let(:instance) { model.new }
  let(:value)    { 'Jane Doe' }

  it { should be(value) }

  specify do
    expect { subject }.to change { instance.name }.to(value)
  end
end
