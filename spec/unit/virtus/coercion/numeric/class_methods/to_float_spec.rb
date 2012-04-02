require 'spec_helper'

describe Virtus::Coercion::Numeric, '.to_float' do
  subject { object.to_float(numeric) }

  let(:object)  { described_class }
  let(:numeric) { Rational(2, 2)  }

  it { should eql(1.0) }
end
