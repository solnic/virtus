require 'spec_helper'

describe Virtus, '.new' do
  let(:model) {
    Class.new {
      include Virtus

      attribute :id,    Integer
      attribute :name,  String, :default => 'John Doe'
      attribute :alias, String, :default => 'jdoe', :allow_nil => false
      attribute :email, String, :default => 'john@doe.com', :lazy => true, :writer => :private
      attribute :age,   Integer, :default => 18, :allow_nil => false, :lazy => true
    }
  }

  context 'without attribute hash' do
    subject { model.new }

    it 'sets default values for non-lazy attributes' do
      expect(subject.instance_variable_get('@name')).to eql('John Doe')
      expect(subject.instance_variable_get('@alias')).to eql('jdoe')
    end

    it 'skips setting default values for lazy attributes' do
      expect(subject.instance_variable_get('@email')).to be(nil)
      expect(subject.instance_variable_get('@age')).to be(nil)
    end
  end

  context 'with attribute hash' do
    subject { model.new(:id => 1, :name => 'Jane Doe', :alias => nil, :age => nil) }

    it 'sets attributes with public writers' do
      expect(subject.id).to be(1)
      expect(subject.name).to eql('Jane Doe')
    end

    it 'sets default values for attributes assigned as nil without allow_nil' do
      expect(subject.alias).to eql('jdoe')
    end

    it 'sets default values for lazy attributes assigned as nil without allow_nil' do
      expect(subject.age).to eql(18)
    end

    it 'skips setting attributes with private writers' do
      expect(subject.instance_variable_get('@email')).to be(nil)
    end
  end

end
