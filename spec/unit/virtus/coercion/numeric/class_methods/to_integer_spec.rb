require 'spec_helper'

describe Virtus::Coercion::Numeric, '.to_integer' do
  subject { object.to_integer(numeric) }

  let(:object)  { described_class }
  let(:numeric) { Rational(2, 2)  }

  it { should eql(1) }
end
