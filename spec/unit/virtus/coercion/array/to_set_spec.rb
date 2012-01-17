require 'spec_helper'

describe Virtus::Coercion::Array, '.to_set' do
  subject { object.to_set(array) }

  let(:object) { described_class        }
  let(:array)  { [ 'a', 1, 'b', 2, 'b', 1, 'a', 2 ] }

  it { should be_instance_of(Set) }

  it { should eql(Set[ 'a', 1, 'b', 2 ]) }
end
