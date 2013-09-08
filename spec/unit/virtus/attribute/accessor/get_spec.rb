require 'spec_helper'

describe Virtus::Attribute::Accessor, '#get' do
  subject { object.get(instance) }

  let(:object) { described_class.new(reader, writer) }

  let(:reader)        { double('reader', :instance_variable_name => :@test) }
  let(:writer)        { double('writer', :default_value => default_value) }
  let(:default_value) { double('default_value') }

  let(:instance) { Class.new { attr_accessor :test }.new }

  let(:value) { 'other' }

  before do
    instance.test = value
    reader.should_receive(:call).with(instance).and_return(value)
  end

  it { should be(value) }
end
