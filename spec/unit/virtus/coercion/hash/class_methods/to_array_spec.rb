require 'spec_helper'

describe Virtus::Coercion::Hash, '.to_array' do
  subject { object.to_array(hash) }

  let(:object) { described_class        }
  let(:hash)   { { 'a' => 1, 'b' => 2 } }

  it { should be_instance_of(Array) }

  it { should =~ [ [ 'a', 1 ], [ 'b', 2 ] ] }
end
