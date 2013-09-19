require 'spec_helper'

describe Virtus, '#set_default_attributes!' do
  subject { object.set_default_attributes! }

  let(:model) {
    Class.new {
      include Virtus

      attribute :name, String,  :default => 'foo', :lazy => true
      attribute :age,  Integer, :default => 30
    }
  }

  let(:object) { model.new }

  before do
    object.set_default_attributes!
  end

  it { should be(object) }

  its(:name) { should eql('foo') }
  its(:age)  { should be(30) }
end
