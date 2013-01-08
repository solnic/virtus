require 'spec_helper'

describe Virtus::Attribute::AccessorMethod, '#call' do
  subject { object.call }

  let(:object) { described_class.new(:name) }

  specify do
    expect { subject }.to raise_error(NotImplementedError)
  end
end
