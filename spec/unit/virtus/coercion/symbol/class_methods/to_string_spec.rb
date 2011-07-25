require 'spec_helper'

describe Virtus::Coercion::Symbol, '.to_string' do
  subject { object.to_string(symbol) }

  let(:object) { described_class }
  let(:symbol) { :piotr          }

  it { should be_instance_of(String) }

  it { should eql('piotr') }
end
