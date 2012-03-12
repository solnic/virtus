require 'spec_helper'

describe Virtus::InstanceMethods, '#initialize' do
  let(:described_class) do
    Class.new do
      include Virtus
      attribute :name, String
    end
  end

  let(:subject) do
    described_class.new(attributes)
  end

  context "with valid argument" do
    let(:attributes) do
      {:name => 'john'}
    end

    it 'sets attributes' do
      subject.name.should == attributes[:name]
    end
  end

  context "with 'non-hashy' argument" do
    let(:attributes) { '' }

    it 'does not try to set attributes' do
      expect { subject }.to_not raise_error(NoMethodError)
    end
  end
end
