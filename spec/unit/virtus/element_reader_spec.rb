require 'spec_helper'

describe Virtus, '#[]' do
  subject { object[:test] }

  let(:model) {
    Class.new {
      include Virtus

      attribute :test, String
    }
  }

  let(:object) { model.new }

  before do
    object.test = 'foo'
  end

  it { should eq('foo') }
end
