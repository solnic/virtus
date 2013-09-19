require 'spec_helper'

describe Virtus::Attribute, '#set' do
  subject { object.set(instance, value) }

  let(:object) { described_class.build(String, options.merge(:name => name)) }

  let(:model)    { Class.new { attr_reader :test } }
  let(:name)     { :test }
  let(:instance) { model.new }
  let(:value)    { 'Jane Doe' }
  let(:options)  { {} }

  it { should be(value) }

  context 'without coercion' do
    specify do
      expect { subject }.to change { instance.test }.to(value)
    end
  end

  context 'with coercion' do
    let(:value) { :'Jane Doe' }

    specify do
      expect { subject }.to change { instance.test }.to('Jane Doe')
    end
  end
end
