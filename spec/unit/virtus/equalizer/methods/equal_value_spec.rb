require 'spec_helper'

describe Virtus::Equalizer::Methods, '#==' do
  subject { object == other }

  let(:object) { described_class.new }

  let(:described_class) do
    Class.new do
      include Virtus::Equalizer::Methods

      def cmp?(comparator, other)
        !!(comparator and other)
      end
    end
  end

  context 'with the same object' do
    let(:other) { object }

    it { should be(true) }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { should be(true) }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an equivalent object of a subclass' do
    let(:other) { Class.new(described_class).new }

    it { should be(true) }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an object of another class' do
    let(:other) { Class.new.new }

    it { should be(false) }

    it 'is symmetric' do
      should eql(other == object)
    end
  end
end
