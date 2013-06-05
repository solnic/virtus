require 'spec_helper'

describe Virtus, '.module' do
  subject { object.module(&block) }

  let(:object) { described_class }

  let(:block) { Proc.new { |config| config.coerce = false } }

  it { expect(subject).to be_kind_of(Module) }
  it { expect(subject).to be_kind_of(Virtus::ModuleExtensions) }
  it { expect(subject).to respond_to(:included) }
  it { expect(subject).to respond_to(:attribute) }
end
