require 'spec_helper'

describe Virtus::Options, '#options' do
  subject { object.options }

  let(:object) do
    Class.new do
      extend Virtus::Options, DescendantsTracker
    end
  end

  context 'with an option that has a default value' do
    let(:default_value) { stub('default_value') }

    before do
      object.accept_options :name
      object.name default_value
    end

    it { should be_instance_of(Hash) }

    it { should eql(:name => default_value) }
  end

  context 'with an option that does not have a default value' do
    before do
      object.accept_options :name
    end

    it { should be_instance_of(Hash) }

    it { should be_empty }
  end
end
