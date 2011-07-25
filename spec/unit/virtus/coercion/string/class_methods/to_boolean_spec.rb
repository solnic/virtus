require 'spec_helper'

describe Virtus::Coercion::String, '.to_boolean' do
  subject { object.to_boolean(string) }

  let(:object) { described_class }

  %w[ 1 t true T TRUE ].each do |value|
    context "with #{value.inspect}" do
      let(:string) { value }

      it { should be(true) }
    end
  end

  %w[ 0 f false F FALSE ].each do |value|
    context "with #{value.inspect}" do
      let(:string) { value }

      it { should be(false) }
    end
  end

  context 'with an invalid boolean string' do
    let(:string) { 'non-boolean' }

    it { should equal(string) }
  end
end
