require 'spec_helper'

describe Virtus, '#freeze' do
  subject { object.freeze }

  let(:model) {
    Class.new {
      include Virtus

      attribute :test, String, :default => 'foo'
    }
  }

  let(:object) { model.new }

  it { should be_frozen }

  its(:test) { should eq('foo') }
end
