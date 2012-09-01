require 'spec_helper'

describe Virtus::InstanceMethods, '#initialize' do
  let(:described_class) do
    Class.new do
      include Virtus
      attribute :name, String
    end
  end

  context 'with no arguments' do
    subject { described_class.new }

    it 'does not set attributes' do
      subject.name.should be_nil
    end
  end

  context 'with nil' do
    subject { described_class.new(nil) }

    it 'does not set attributes' do
      subject.name.should be_nil
    end
  end

  context 'with an argument that responds to #to_hash' do
    subject { described_class.new(:name => "Aleksandr") }

    it 'sets attributes' do
      subject.name.should == "Aleksandr"
    end
  end

  context' with an argument that does not respond to #to_hash' do
    subject { described_class.new(Object.new) }

    specify { expect { subject }.to raise_error(NoMethodError) }
  end
end
