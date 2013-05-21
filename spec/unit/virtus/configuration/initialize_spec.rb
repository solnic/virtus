require 'spec_helper'

describe Virtus::Configuration, '#initialize' do
  subject { described_class.new() }

  its(:coerce) { should eq(true) }
end
