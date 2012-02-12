require 'spec_helper'

describe Virtus::Coercion::String, '.to_constant' do
  subject { object.to_constant(string) }

  let(:object) { described_class }

  context 'with a non-namespaced name' do
    let(:string) { 'String' }

    it { should be(String) }
  end

  context 'with a non-namespaced qualified name' do
    let(:string) { '::String' }

    it { should be(String) }
  end

  context 'with a namespaced name' do
    let(:string) { 'Virtus::Coercion::String' }

    it { should be(Virtus::Coercion::String) }
  end

  context 'with a namespaced qualified name' do
    let(:string) { '::Virtus::Coercion::String' }

    it { should be(Virtus::Coercion::String) }
  end

  context 'with a name outside of the namespace' do
    let(:string) { 'Virtus::Object' }

    specify { expect { subject }.to raise_error(NameError) }
  end

  context 'when the name is unknown' do
    let(:string) { 'Unknown' }

    specify { expect { subject }.to raise_error(NameError) }
  end

  context 'when the name is invalid' do
    let(:string) { 'invalid' }

    specify { expect { subject }.to raise_error(NameError) }
  end
end
