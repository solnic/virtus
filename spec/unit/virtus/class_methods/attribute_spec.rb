require 'spec_helper'

describe Virtus::ClassMethods, '.attribute' do
  subject { described_class.attribute(:name, type) }

  let(:described_class) do
    Class.new { include Virtus }
  end

  context 'with a string as type' do
    let(:type) { String }

    it { should be(described_class) }
  end

  context 'with a virtus class as type' do
    let(:type) { Class.new { include Virtus } }

    it { should be(described_class) }

    it 'sets model option' do
      subject.attributes[:name].options[:model].should be(type)
    end
  end
end
