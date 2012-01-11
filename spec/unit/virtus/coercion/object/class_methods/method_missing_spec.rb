require 'spec_helper'

shared_examples_for 'no method error' do
  specify do
    expect { subject }.to raise_error(NoMethodError)
  end
end

describe Virtus::Coercion::Object, '.method_missing' do
  subject { described_class.send(method_name, value) }

  let(:value) { '1' }

  context 'with a non-typecast method' do
    let(:method_name) { 'not_here' }

    it_should_behave_like 'no method error'
  end

  Virtus::Attribute::Object.descendants.each do |attribute|
    let(:method_name) { attribute.coercion_method }

    context "with #{attribute.coercion_method.inspect} and an input value" do
      it { should equal(value) }
    end

    context "with #{attribute.coercion_method.inspect} and without an input value" do
      subject { described_class.send(method_name) }

      it_should_behave_like 'no method error'
    end
  end
end
