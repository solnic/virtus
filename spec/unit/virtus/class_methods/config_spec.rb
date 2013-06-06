require 'spec_helper'

describe Virtus, 'config' do
  subject { described_class.config { |config| config.coerce = false } }

  after do
    Virtus.coerce = true
  end

  its(:coerce)  { should eq(false) }
  its(:coercer) { should be_instance_of(Coercible::Coercer) }
end
