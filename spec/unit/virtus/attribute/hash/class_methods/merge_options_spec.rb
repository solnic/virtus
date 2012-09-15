require 'spec_helper'

describe Virtus::Attribute::Hash, '.merge_options' do
  subject { described_class.merge_options(type, options) }

  let(:type)        { { String => Integer } }
  let(:options)     { { :opt => 'val' } }

  context 'when `type` responds to `size`' do
    context 'when size is == 1' do
      specify { subject[:opt].should == 'val'          }
      specify { subject[:key_type].should == String    }
      specify { subject[:value_type].should == Integer }
    end

    context 'when size is > 1' do
      let(:type) { { :opt1 => 'val1', :opt2 => 'val2' } }

      it 'should raise ArgumentError' do
        message = "more than one [key => value] pair in `#{type.inspect}`"
        expect { subject }.to raise_error(ArgumentError, message)
      end
    end
  end

  context 'when `type` does not respond to `size`' do
    before do
      type.should_receive(:respond_to?).with(:size).and_return(false)
    end

    it { should be_eql(options) }
  end
end
