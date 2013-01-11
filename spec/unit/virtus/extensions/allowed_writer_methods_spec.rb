require 'spec_helper'

shared_examples_for "#allowed_writer_methods" do
  it { should include('virtus_attribute=') }
  it { should include('some_other_attribute=') }
  it { should_not include('private_attribute=') }

  %w[ == != === []= attributes= ].each do |invalid_method|
    it { should_not include(invalid_method) }
  end

  it { should be_frozen }
end

describe Virtus::Extensions, '#allowed_writer_methods' do
  subject { object.send :allowed_writer_methods }

  let(:klass) do
    Class.new do
      include Virtus
      attribute :virtus_attribute, String
      attr_accessor :some_other_attribute
    private
      attr_accessor :private_attribute
    end
  end

  let(:mod) do
    Module.new do
      include Virtus
      attribute :virtus_attribute, String
      attr_accessor :some_other_attribute
    private
      attr_accessor :private_attribute
    end
  end

  context "with a class" do
    let(:object) { klass }

    it_behaves_like "#allowed_writer_methods"
  end

  context "with an instance" do
    let(:object) {
      instance = Class.new { attr_accessor :some_other_attribute }.new.extend(Virtus)
      instance.attribute :virtus_attribute, String
      instance
    }

    it_behaves_like "#allowed_writer_methods"
  end
end
