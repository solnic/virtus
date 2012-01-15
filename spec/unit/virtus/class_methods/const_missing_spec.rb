require 'spec_helper'

describe Virtus::ClassMethods, '#const_missing' do
  let(:object) { Class.new { extend Virtus::ClassMethods } }

  context 'with a constant name that is known' do
    subject { object.class_eval 'String' }

    it 'returns the constant' do
      subject.should be(String)
    end
  end

  context 'with a constant name that corresponds to a Virtus::Attribute' do
    subject { object.class_eval 'Boolean' }

    it 'determines the correct type' do
      subject.should be(Virtus::Attribute::Boolean)
    end
  end

  context 'with a constant name that is unknown' do
    subject { object.class_eval 'Unknown' }

    specify { expect { subject }.to raise_error(NameError) }
  end
end
