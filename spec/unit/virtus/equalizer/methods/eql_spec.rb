require 'spec_helper'

describe Virtus::Equalizer::Methods, '#eql?' do
  subject { object.eql?(other) }

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
      should eql(other.eql?(object))
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { should be(true) }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end

  context 'with an equivalent object of a subclass' do
    let(:other) { Class.new(described_class).new }

    it { should be(false) }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end
end
