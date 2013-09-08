require 'spec_helper'

describe Virtus, '.coercer' do
  subject { described_class.coercer(&block) }

  let(:block) { Proc.new {} }

  it { expect(subject).to be_instance_of(Coercible::Coercer) }
end
