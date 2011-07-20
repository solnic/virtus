require 'spec_helper'

describe Virtus::Typecast, '#[]' do
  %w(BigDecimal Date DateTime FalseClass Fixnum
     Float Hash String Symbol Time TrueClass).each do |class_name|

    context "with #{class_name.inspect}" do
      subject { described_class[class_name] }

      it { should == described_class.const_get(class_name) }
    end

  end

  context 'with a name of a class not defined in Typecast' do
    subject { described_class['Set'] }

    it { should == Virtus::Typecast::Object }
  end
end
