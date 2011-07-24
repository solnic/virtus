require 'spec_helper'

describe Virtus::TypeLookup, '#determine_type' do
  subject { object.determine_type(class_or_name) }

  let(:object) do
    Class.new do
      extend Virtus::DescendantsTracker
      extend Virtus::TypeLookup
    end
  end

  let(:descendant) do
    object.const_set :String, Class.new(object) {
      def self.primitive
        ::String
      end
    }
  end

  context 'with a TypeLookup class' do
    context 'when the argument is a descendant of the object' do
      let(:class_or_name) { descendant }

      it { should equal(descendant) }
    end

    context 'when the argument is the same object' do
      let(:class_or_name) { object }

      it { should be_nil }
    end
  end

  context 'with a class' do
    context 'when the argument is a known primitive' do
      let(:class_or_name) { ::String }

      it { should equal(descendant) }
    end

    context 'when the argument is an unknown class' do
      let(:class_or_name) { Class.new }

      it { should be_nil }
    end
  end

  context 'with an instance' do
    context 'when the argument is the name of a known constant' do
      let(:class_or_name) { 'String' }

      it { should equal(descendant) }
    end

    context 'when the argument does not stringify to a valid constant name' do
      let(:class_or_name) { Object.new }

      it { should be_nil }
    end

    context 'when the argument is not the name of a known constant' do
      let(:class_or_name) { 'Unknown' }

      it { should be_nil }
    end
  end
end
