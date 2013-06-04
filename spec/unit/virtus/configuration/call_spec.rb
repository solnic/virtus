require 'spec_helper'

describe Virtus::Configuration, '#call' do
  subject { described_class.new.call(&block) } # { |config| config.coerce = false } }

  let(:block) { Proc.new {} }

  its(:coercer) { should be_instance_of(Coercible::Coercer) }

  context "when coerce option isn't explicity set" do
    its(:coerce) { should be(true) }
  end

  context "when coerce option is set to false" do
    let(:block) { Proc.new { |config| config.coerce = false } }

    its(:coerce) { should be(false) }
  end
end
