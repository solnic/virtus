require 'spec_helper'

describe Virtus::ModuleBuilder, '.call' do
  let(:object) { described_class }

  context 'without a block' do
    subject { object.call }

    it { expect(subject).to be_kind_of(Module) }
    it { expect(subject).to be_kind_of(Virtus::ModuleExtensions) }
    it { expect(subject).to respond_to(:included) }
    it { expect(subject).to respond_to(:attribute) }
  end

  context 'with a block' do
    subject { object.call(&block) }

    let(:block) { Proc.new{} }

    it { expect(subject).to be_kind_of(Module) }
    it { expect(subject).to be_kind_of(Virtus::ModuleExtensions) }
    it { expect(subject).to respond_to(:included) }
    it { expect(subject).to respond_to(:attribute) }
  end

#  context 'with
end
