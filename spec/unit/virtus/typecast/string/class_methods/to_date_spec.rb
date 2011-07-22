require 'spec_helper'

describe Virtus::Typecast::String, '.to_date' do
  subject { described_class.to_date(string) }

  context 'with a valid date string' do
    let(:string) { "July, 22th, 2011" }

    it { should be_instance_of(Date) }

    its(:year)  { should == 2011 }
    its(:month) { should == 7    }
    its(:day)   { should == 22   }
  end

  context 'with an invalid date string' do
    let(:string) { 'non-date' }
    it { should == string }
  end
end
