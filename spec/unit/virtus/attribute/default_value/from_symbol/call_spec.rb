require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromSymbol, '#call' do
  subject { object.call(instance) }

  let(:object)    { described_class.new(name) }
  let(:klass)     { Class.new { def set_default; :retval; end } }
  let(:instance)  { klass.new }

  context "when symbol is not a method name" do
    let(:name) { :not_a_method }

    it { should be(name) }
  end

  context "when symbol is a method name" do
    let(:name) { :set_default }

    context "when method is public" do
      it { should be(:retval) }
    end

    context "when method is private" do
      before do
        klass.send(:private, :set_default)
      end

      it { should be(:retval) }
    end

    context "when method is protected" do
      before do
        klass.send(:protected, :set_default)
      end

      it { should be(:retval) }
    end
  end
end
