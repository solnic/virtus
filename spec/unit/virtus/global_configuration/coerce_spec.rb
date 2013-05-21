require 'spec_helper'

describe Virtus, '.coerce' do
  subject { described_class.coerce = false }

  after do
    Virtus.coerce = true
  end

  it(:coerce)  { should be(false) }
end
