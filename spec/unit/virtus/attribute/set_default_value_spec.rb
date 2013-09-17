require 'spec_helper'

describe Virtus::Attribute, '#set_default_value' do
  let(:object) { described_class.build(String, options.merge(:name => name, :default => default)) }

  let(:model)    { Class.new { def name; 'model'; end; attr_reader :test } }
  let(:name)     { :test }
  let(:instance) { model.new }
  let(:options)  { {} }

  before { object.set_default_value(instance) }

  context 'with a nil' do
    subject { instance }

    let(:default) { nil }

    its(:test) { should be(nil) }
    its(:instance_variables) { should include(:'@test') }
  end

  context 'with a non-clonable object' do
    subject { instance }

    let(:object)  { described_class.build('Boolean', options.merge(:name => name, :default => default)) }
    let(:default) { true }

    its(:test) { should be(true) }
    its(:instance_variables) { should include(:'@test') }
  end

  context 'with a clonable' do
    subject { instance }

    let(:default) { [] }

    its(:test) { should eq(default) }
    its(:test) { should_not be(default) }
  end

  context 'with a callable' do
    subject { instance }

    let(:default) { lambda { |model, attribute| "#{model.name}-#{attribute.name}" } }

    its(:test) { should eq('model-test') }
  end

  context 'with a symbol' do
    subject { instance }

    context 'when it is a method name' do
      let(:default) { :set_test }

      context 'when method is public' do
        let(:model) { Class.new { attr_reader :test; def set_test; @test = 'hello world'; end } }

        its(:test) { should eq('hello world') }
      end

      context 'when method is private' do
        let(:model) { Class.new { attr_reader :test; private; def set_test; @test = 'hello world'; end } }

        its(:test) { should eq('hello world') }
      end
    end

    context 'when it is not a method name' do
      let(:default) { :hello_world }

      its(:test) { should eq('hello_world') }
    end
  end
end
