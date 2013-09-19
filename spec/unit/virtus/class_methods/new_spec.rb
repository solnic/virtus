require 'spec_helper'

describe Virtus, '.new' do
  let(:model) {
    Class.new {
      include Virtus

      attribute :id,    Integer
      attribute :name,  String, :default => 'John Doe'
      attribute :email, String, :default => 'john@doe.com', :lazy => true, :writer => :private
    }
  }

  context 'without attribute hash' do
    subject { model.new }

    it 'sets default values for non-lazy attributes' do
      expect(subject.instance_variable_get('@name')).to eql('John Doe')
    end

    it 'skips setting default values for lazy attributes' do
      expect(subject.instance_variable_get('@email')).to be(nil)
    end
  end

  context 'with attribute hash' do
    subject { model.new(:id => 1, :name => 'Jane Doe') }

    it 'sets attributes with public writers' do
      expect(subject.id).to be(1)
      expect(subject.name).to eql('Jane Doe')
    end

    it 'skips setting attributes with private writers' do
      expect(subject.instance_variable_get('@email')).to be(nil)
    end
  end

end
