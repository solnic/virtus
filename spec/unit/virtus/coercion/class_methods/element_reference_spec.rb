require 'spec_helper'

describe Virtus::Coercion, '#[]' do
  %w[ Decimal Date DateTime FalseClass Integer Float Hash String Symbol Time TrueClass ].each do |class_name|
    context "with #{class_name.inspect}" do
      subject { described_class[class_name] }

      it { should == described_class.const_get(class_name) }
    end
  end

  context 'with a name of a class not defined in Coercion' do
    subject { described_class['Set'] }

    it { should == Virtus::Coercion::Object }
  end
end
