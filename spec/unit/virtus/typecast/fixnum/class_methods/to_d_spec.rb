require 'spec_helper'

describe Virtus::Typecast::Fixnum, '.to_d' do
  subject { object.to_d(fixnum) }

  let(:object) { described_class }
  let(:fixnum) { 1               }

  it { should be_instance_of(BigDecimal) }

  it { should eql(BigDecimal('1.0')) }
end
