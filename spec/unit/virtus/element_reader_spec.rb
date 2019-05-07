require 'spec_helper'

describe Virtus, '#[]' do
  subject { object[:test] }

  let(:model) do
    Class.new do
      include Virtus

      attribute :test, String
    end
  end

  let(:object) { model.new }

  before do
    object.test = 'foo'
  end

  it { is_expected.to eq('foo') }
end
