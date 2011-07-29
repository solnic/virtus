require 'spec_helper'

describe Virtus::Coercion::Integer, '.to_string' do
  subject { object.to_string(integer) }

  let(:object)  { described_class }
  let(:integer) { 1               }

  it { should be_instance_of(String) }

  it { should eql('1') }
end
