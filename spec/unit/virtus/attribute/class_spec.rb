require 'spec_helper'

describe Virtus::Attribute::Class do
  describe '#coerce' do
    let(:attribute) { described_class.new(:type) }

    subject { attribute.coerce(value) }

    context 'with a String' do
      let(:value) { 'String' }

      it { should be(String) }
    end
  end

end
