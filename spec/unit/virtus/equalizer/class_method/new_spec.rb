require 'spec_helper'

describe Virtus::Equalizer, '.new' do
  let(:object) { described_class }
  let(:name)   { 'User'          }

  let(:klass) do
    klass = ::Class.new
    klass.send(:include, subject)
    klass
  end

  context 'with a name' do
    subject { object.new(name) }

    let(:instance) { klass.new }

    it { should be_instance_of(object) }

    describe '#eql?' do
      context 'when the objects are similar' do
        let(:other) { instance.dup }

        it { instance.eql?(other).should be(true) }
      end

      context 'when the objects are different' do
        let(:other) { stub('other') }

        it { instance.eql?(other).should be(false) }
      end
    end

    describe '#==' do
      context 'when the objects are similar' do
        let(:other) { instance.dup }

        it { (instance == other).should be(true) }
      end

      context 'when the objects are different' do
        let(:other) { stub('other') }

        it { (instance == other).should be(false) }
      end
    end

    describe '#hash' do
      it { instance.hash.should eql(klass.hash) }
    end

    describe '#inspect' do
      it { instance.inspect.should eql('#<User>') }
    end
  end

  context 'with a name and keys' do
    subject { object.new(name, keys) }

    let(:keys)       { [ :first_name ].freeze }
    let(:first_name) { 'John'                 }

    let(:instance) do
      instance = klass.new
      instance.first_name = first_name
      instance
    end

    before do
      klass.send(:attr_accessor, *keys)
    end

    it { should be_instance_of(object) }

    describe '#eql?' do
      context 'when the objects are similar' do
        let(:other) { instance.dup }

        it { instance.eql?(other).should be(true) }
      end

      context 'when the objects are different' do
        let(:other) { stub('other') }

        it { instance.eql?(other).should be(false) }
      end
    end

    describe '#==' do
      context 'when the objects are similar' do
        let(:other) { instance.dup }

        it { (instance == other).should be(true) }
      end

      context 'when the objects are different' do
        let(:other) { stub('other') }

        it { (instance == other).should be(false) }
      end
    end

    describe '#hash' do
      it { instance.hash.should eql(klass.hash ^ first_name.hash) }
    end

    describe '#inspect' do
      it { instance.inspect.should eql('#<User first_name="John">') }
    end
  end
end
