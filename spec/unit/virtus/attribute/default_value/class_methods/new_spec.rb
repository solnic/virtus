require 'spec_helper'

describe Virtus::Attribute::DefaultValue, '.new' do
  subject { described_class.new(attribute, value) }

  let(:attribute) { Virtus::Attribute::String.new(:attribute) }

  context 'with a value that can be duped' do
    let(:value) { 'something' }

    its(:value) { should     eql(value)   }
    its(:value) { should_not equal(value) }
  end

  context 'with a value that cannot be duped' do
    [ nil, true, false, 1, :symbol ].each do |value|
      context "with #{value.inspect}" do
        let(:value) { value }

        its(:value) { should equal(value) }
      end
    end
  end
end
