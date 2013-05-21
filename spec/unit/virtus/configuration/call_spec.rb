require 'spec_helper'

describe Virtus::Configuration, '#call' do
  subject { described_class.new.call { |config| config.coerce = false } }

  its(:coerce)  { should eq(false) }
  its(:coercer) { should be_instance_of(Coercible::Coercer) }
end
