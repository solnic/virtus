require 'spec_helper'

describe Virtus::Coercion::Numeric, '.to_string' do
  subject { object.to_string(numeric) }

  let(:object)  { described_class }
  let(:numeric) { Rational(2, 2)  }

  it { should eql('1') }
end
