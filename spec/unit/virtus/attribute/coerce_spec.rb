require 'spec_helper'

describe Virtus::Attribute, '#coerce' do
  subject { object.coerce(input) }

  fake(:coercer) { Virtus::Attribute::Coercer }

  let(:object) { described_class.build(String, :coercer => coercer) }
  let(:input)  { '1' }
  let(:output) { 1 }

  it 'uses coercer to coerce the input value' do
    stub(coercer).call(input) { output }

    expect(subject).to be(output)

    expect(coercer).to have_received.call(input)
  end
end
