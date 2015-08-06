require 'spec_helper'

describe Virtus, '#attributes' do

  shared_examples_for 'attribute hash' do
    it 'includes all attributes' do
      subject.attributes = { :test => 'Hello World', :test_priv => 'Yo' }

      expect(subject.attributes).to eql(:test => 'Hello World')
    end
  end

  context 'with a class' do
    let(:model) {
      Class.new {
        include Virtus

        attribute :test,      String
        attribute :test_priv, String, :reader => :private
      }
    }

    it_behaves_like 'attribute hash' do
      subject { model.new }
    end
  end

  context 'with an instance' do
    subject { model.new }

    let(:model) { Class.new }

    before do
      subject.extend(Virtus)
      subject.attribute :test,      String
      subject.attribute :test_priv, String, :reader => :private
    end

    it_behaves_like 'attribute hash'
  end

  context "#to_h / #to_hash" do
    let(:model) {
      child = Class.new {
        include Virtus

        attribute :d, String
      }

      Class.new {
        include Virtus

        attribute :a, String
        attribute :c, child
      }
    }

    subject { model.new a: "b", c: {d: "e"} }

    it "deeply converts to a hash" do
      expect(subject.to_h).to eql(a: "b", c: {d: "e"})
      expect(subject.to_hash).to eql(a: "b", c: {d: "e"})
    end
  end
end
