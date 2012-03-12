require 'spec_helper'

describe Virtus::InstanceMethods, '#initialize' do
  let(:described_class) do
    Class.new do
      include Virtus
      attribute :name, String
    end
  end

  context 'with Hash argument' do
    subject { described_class.new(:name => name) }

    let(:name) { stub('name') }

    it 'sets attributes' do
      subject.name.should equal(name)
    end
  end

  context 'with nil argument' do
    subject { described_class.new(nil) }

    it 'does not set attributes' do
      subject.name.should be_nil
    end
  end

  context 'with no arguments' do
    subject { described_class.new }

    it 'does not set attributes' do
      subject.name.should be_nil
    end
  end

  context' with argument that does not respond to #to_hash' do
    subject { described_class.new(Object.new) }

    specify { expect { subject }.to raise_error(NoMethodError) }
  end
end
