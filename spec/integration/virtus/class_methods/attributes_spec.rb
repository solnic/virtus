require 'spec_helper'

describe Virtus::ClassMethods, '.attributes' do
  let(:described_class) do
    Class.new { include Virtus }
  end

  it { described_class.should respond_to(:attributes)  }

  describe ".attributes" do
    before do
      described_class.attribute(:name, String)
      described_class.attribute(:age,  Integer)
    end

    subject { described_class.attributes }

    it "returns an attributes hash" do
      subject.should be_kind_of(Virtus::AttributeSet)
    end
  end
end
