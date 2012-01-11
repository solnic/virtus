require 'spec_helper'

describe Virtus::Coercion::TrueClass, '.to_string' do
  subject { object.to_string(true_class) }

  let(:object)     { described_class }
  let(:true_class) { true            }

  it { should be_instance_of(String) }

  it { should eql('true') }
end
