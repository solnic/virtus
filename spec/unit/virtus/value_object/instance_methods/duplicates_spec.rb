require 'spec_helper'

describe Virtus::ValueObject::InstanceMethods, 'duplication' do
  let(:described_class) do
    Class.new do
      include Virtus::ValueObject

      attribute :name, String
    end
  end

  subject { described_class.new }

  it '#clone returns the same instance' do
    subject.should equal(subject.clone)
  end

  it '#dup returns the same instance' do
    subject.should equal(subject.dup)
  end

end
