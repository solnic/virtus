require 'spec_helper'

describe Virtus, '#freeze' do
  subject { object.freeze }

  let(:model) {
    Class.new {
      include Virtus

      attribute :name, String,  :default => 'foo', :lazy => true
      attribute :age,  Integer, :default => 30
      attribute :rand, Float,   :default => Proc.new { rand }
    }
  }

  let(:object) { model.new }

  it { should be_frozen }

  its(:name) { should eql('foo') }
  its(:age)  { should be(30) }

  it "does not change dynamic default values" do
    original_value = object.rand
    object.freeze
    expect(object.rand).to eq original_value
  end

  it "does not change default attributes that have been explicitly set" do
    object.rand = 3.14
    object.freeze
    expect(object.rand).to eq 3.14
  end
end
