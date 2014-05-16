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

    describe '#test' do
      subject { super().test }
      it { should be(nil) }
    end

    describe '#instance_variables' do
      subject { super().instance_variables }
      it { should include(:'@test') }
    end
  end

  context 'with a non-clonable object' do
    subject { instance }

    let(:object)  { described_class.build('Boolean', options.merge(:name => name, :default => default)) }
    let(:default) { true }

    describe '#test' do
      subject { super().test }
      it { should be(true) }
    end

    describe '#instance_variables' do
      subject { super().instance_variables }
      it { should include(:'@test') }
    end
  end

  context 'with a clonable' do
    subject { instance }

    let(:default) { [] }

    describe '#test' do
      subject { super().test }
      it { should eq(default) }
    end

    describe '#test' do
      subject { super().test }
      it { should_not be(default) }
    end
  end

  context 'with a callable' do
    subject { instance }

    let(:default) { lambda { |model, attribute| "#{model.name}-#{attribute.name}" } }

    describe '#test' do
      subject { super().test }
      it { should eq('model-test') }
    end
  end

  context 'with a symbol' do
    subject { instance }

    context 'when it is a method name' do
      let(:default) { :set_test }

      context 'when method is public' do
        let(:model) { Class.new { attr_reader :test; def set_test; @test = 'hello world'; end } }

        describe '#test' do
          subject { super().test }
          it { should eq('hello world') }
        end
      end

      context 'when method is private' do
        let(:model) { Class.new { attr_reader :test; private; def set_test; @test = 'hello world'; end } }

        describe '#test' do
          subject { super().test }
          it { should eq('hello world') }
        end
      end
    end

    context 'when it is not a method name' do
      let(:default) { :hello_world }

      describe '#test' do
        subject { super().test }
        it { should eq('hello_world') }
      end
    end
  end
end
