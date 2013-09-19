require 'spec_helper'

describe Virtus, '#freeze' do
  subject { object.freeze }

  let(:model) {
    Class.new {
      include Virtus

      attribute :name, String,  :default => 'foo', :lazy => true
      attribute :age,  Integer, :default => 30
    }
  }

  let(:object) { model.new }

  it { should be_frozen }

  its(:name) { should eql('foo') }
  its(:age)  { should be(30) }
end
