require 'spec_helper'

describe Virtus::ValueObject::Equalizer, '#<<' do
  let(:equalizer) { described_class.new(:user, [ :first_name ]) }

  let(:klass) do
    klass = Class.new { attr_accessor :first_name, :last_name }
    klass.send(:include, equalizer)
  end

  let(:user_one) { klass.new }
  let(:user_two) { klass.new }

  let(:first_name) { 'john' }
  let(:last_name)  { 'doe'  }

  before do
    equalizer << :last_name

    user_one.first_name = first_name
    user_one.last_name  = last_name

    user_two.first_name = first_name
    user_two.last_name  = last_name
  end

  describe "#eql?" do
    subject { user_one.eql?(user_two) }

    context 'when key values match' do
      it { should be(true) }
    end

    context 'when key values match' do
      before { user_two.last_name = 'other' }

      it { should be(false) }
    end
  end

  describe "#==?" do
    subject { user_one == user_two }

    context 'when key values match' do
      it { should be(true) }
    end

    context 'when key values match' do
      before { user_two.last_name = 'other' }

      it { should be(false) }
    end
  end

  describe "#hash" do
    subject { user_one.hash }

    it { should eql(klass.hash ^ first_name.hash ^ last_name.hash) }
  end
end

