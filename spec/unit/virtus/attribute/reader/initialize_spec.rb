require 'spec_helper'

describe Virtus::Attribute::Reader, '#initialize' do
  subject { described_class.new(name, options) }

  let(:name) { 'test' }

  context "without options" do
    let(:options) { Hash.new }

    its(:name)                   { should be(:test) }
    its(:visibility)             { should be(:public) }
    its(:instance_variable_name) { should be(:@test) }
  end

  context "with options specifying visibility" do
    let(:options) { { :visibility => :private } }

    its(:name)       { should be(:test) }
    its(:visibility) { should be(:private) }
  end
end
