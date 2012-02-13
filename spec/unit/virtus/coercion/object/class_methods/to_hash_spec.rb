require 'spec_helper'

describe Virtus::Coercion::Object, '.to_hash' do
  subject { object.to_hash(value) }

  let(:object) { described_class }
  let(:value)  { stub('value')   }

  context 'when the value responds to #to_hash' do
    let(:coerced) { stub('coerced') }

    before do
      value.should_receive(:to_hash).with().and_return(coerced)
    end

    it { should be(coerced) }
  end

  context 'when the value does not respond to #to_hash' do
    it { should be(value) }
  end
end
