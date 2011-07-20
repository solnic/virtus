require 'spec_helper'

describe Virtus::Typecast::Fixnum, '.to_f' do
  subject { object.to_f(fixnum) }

  let(:object) { described_class }
  let(:fixnum) { 1               }

  it { should be_instance_of(Float) }

  it { should eql(1.0) }
end
