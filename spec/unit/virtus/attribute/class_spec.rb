require 'spec_helper'

describe Virtus::Attribute::Class do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)         { :String }
    let(:attribute_value)        { String }
    let(:attribute_value_other)  { 'String' }
    let(:attribute_default)      { 'Object' }
    let(:attribute_default_proc) { lambda { |instance, attribute| attribute.name.to_s } }
  end

  describe '#coerce' do
    let(:attribute) { described_class.new(:type) }

    subject { attribute.coerce(value) }

    context 'with a String' do
      let(:value) { 'String' }

      it { should be(String) }
    end
  end

end
