require 'spec_helper'

describe Virtus::Attribute::AccessorMethod, '#define_method' do
  subject { object.define_method(accessor, mod) }

  let(:object)   { described_class.new(:name) }
  let(:accessor) { double('accessor') }
  let(:mod)      { double('mod') }

  specify do
    expect { subject }.to raise_error(NotImplementedError)
  end
end
