require 'spec_helper'

describe Virtus::Configuration, '.build' do
  subject { described_class.build(&block) }

  let(:block) { Proc.new {} }

  it { expect(subject.coercer).to be_instance_of(Coercible::Coercer) }

  context "when coerce option isn't explicitly set" do
    it { expect(subject.coerce).to be(true) }
  end

  context "when coerce option is set to false" do
    let(:block) { Proc.new { |config| config.coerce = false } }

    it { expect(subject.coerce).to be(false) }
  end
end
