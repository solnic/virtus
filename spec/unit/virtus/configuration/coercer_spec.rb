require 'spec_helper'

describe Virtus::Configuration, '#coercer' do
  subject { described_class.new.coercer(&block) }

  let(:block) { Proc.new {} }

  it { expect(subject).to be_instance_of(Coercible::Coercer) }
end
