require 'spec_helper'

describe Virtus, '.coerce' do
  subject { described_class }

  before do
    subject.coerce = false
  end

  after do
    subject.coerce = true
  end

  it { expect(subject.coerce).to be(false) }
end
