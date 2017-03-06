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

        attribute :foo, String
      }

      Class.new {
        include Virtus

        attribute :bar, String
        attribute :nested_model, child
        attribute :array_of_nested_model, Array[child]

      }
    }

    subject { model.new bar: "1", nested_model: { foo: "2" }, array_of_nested_model: [{ foo: "3" }, { foo: "4" }]  }

    it "deeply converts to a hash" do
      expect(subject.to_h).to eql(bar: "1", nested_model: { foo: "2" }, array_of_nested_model: [{ foo: "3" }, { foo: "4" }] )
      expect(subject.to_hash).to eql(bar: "1", nested_model: { foo: "2" }, array_of_nested_model: [{ foo: "3" }, { foo: "4" }] )
    end
  end
end
