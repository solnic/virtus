require 'spec_helper'

describe Virtus::ValueObject do
  subject { model.new(attributes) }

  let(:attributes) { Hash[:id => 1, :name => 'Jane Doe'] }

  share_examples_for 'a valid value object' do
    its(:id)   { should be(1) }
    its(:name) { should eql('Jane Doe') }

    it 'sets private writers' do
      expect(model.attribute_set[:id]).to_not be_public_writer
      expect(model.attribute_set[:name]).to_not be_public_writer
    end

    it 'disallows mass-assignment' do
      expect(subject.private_methods).to include(:attributes=)
    end

    it 'disallows cloning' do
      expect(subject.clone).to be(subject)
    end

    it 'defines #eql?' do
      expect(subject).to eql(model.new(attributes))
    end

    it 'defines #==' do
      expect(subject == model.new(attributes)).to be(true)
    end

    it 'defines #hash' do
      expect(subject.hash).to eql(model.new(attributes).hash)
    end

    it 'defines #inspect' do
      expect(subject.inspect).to eql('#<Model id=1 name="Jane Doe">')
    end
  end

  context 'using new values {} block' do
    let(:model) {
      Class.new {
        include Virtus

        def self.name
          'Model'
        end

        values do
          attribute :id,   Integer
          attribute :name, String
        end
      }
    }

    it_behaves_like 'a valid value object'
  end

  context 'using deprecated inclusion' do
    let(:model) {
      Class.new {
        include Virtus::ValueObject

        def self.name
          'Model'
        end

        attribute :id,   Integer
        attribute :name, String
      }
    }

    it_behaves_like 'a valid value object'
  end
end
