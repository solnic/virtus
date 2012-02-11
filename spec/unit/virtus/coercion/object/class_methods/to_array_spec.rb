require 'spec_helper'

describe Virtus::Coercion::Object, '.to_array' do
  subject { object.to_array(value) }

  let(:object)  { described_class }
  let(:value)   { Object.new      }
  let(:coerced) { [ value ]       }

  context 'when the value responds to #to_ary' do
    before do
      value.should_receive(:to_ary).with().and_return(coerced)
    end

    it { should be(coerced) }

    it 'does not call #to_a if #to_ary is available' do
      value.should_not_receive(:to_a)
      subject
    end
  end

  context 'when the value responds to #to_a but not #to_ary' do
    before do
      value.should_receive(:to_a).with().and_return(coerced)
    end

    it { should be(coerced) }
  end

  context 'when the value does not respond to #to_ary or #to_a' do
    it { should be_instance_of(Array) }

    it { should == coerced }
  end

  context 'when the value returns nil from #to_ary' do
    before do
      value.should_receive(:to_ary).with().and_return(nil)
    end

    it 'calls #to_a as a fallback' do
      value.should_receive(:to_a).with().and_return(coerced)
      should be(coerced)
    end

    it 'wraps the value in an Array if #to_a is not available' do
      should == coerced
    end
  end
end
