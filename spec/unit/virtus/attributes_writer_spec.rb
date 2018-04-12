require 'spec_helper'

describe Virtus, '#attributes=' do

  shared_examples_for 'mass-assignment' do
    it 'allows writing known attributes' do
      subject.attributes = { :test => 'Hello World' }

      expect(subject.test).to eql('Hello World')
    end

    it 'skips writing unknown attributes' do
      subject.attributes = { :test => 'Hello World', :nothere => 'boom!' }

      expect(subject.test).to eql('Hello World')
    end

    context "with Rails 5 parameters" do
      class FakeParams

        def initialize(hash)
          @hash = hash
        end

        def to_hash
          raise "Cannot be called on unsafe params"
        end

        def to_unsafe_hash
          @hash
        end
      end

      it "safely assigns the hash" do
        subject.attributes = FakeParams.new({ :test => 'Hello World' })
        expect(subject.test).to eql('Hello World')
      end

      it "handles properly if the attributes are not hash like" do
        expect { subject.attributes = 1 }.to raise_error(NoMethodError)
      end
    end
  end

  context 'with a class' do
    let(:model) {
      Class.new {
        include Virtus

        attribute :test, String
      }
    }

    it_behaves_like 'mass-assignment' do
      subject { model.new }
    end

    it 'raises when attributes is not hash-like object' do
      expect { model.new('not a hash, really') }.to raise_error(
        NoMethodError, 'Expected "not a hash, really" to respond to #to_hash'
      )
    end
  end

  context 'with an instance' do
    subject { model.new }

    let(:model) { Class.new }

    before do
      subject.extend(Virtus)
      subject.attribute :test, String
    end

    it_behaves_like 'mass-assignment'
  end
end
