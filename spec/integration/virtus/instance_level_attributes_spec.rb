require 'spec_helper'

describe Virtus, 'instance level attributes' do
  subject do
    subject = Object.new
    subject.singleton_class.send(:include, Virtus)
    subject
  end

  let(:attribute) { subject.singleton_class.attribute(:name, String) }

  before do
    pending if RUBY_VERSION < '1.9'
  end

  context 'adding an attribute' do
    it 'allows setting the attribute value on the instance' do
      attribute
      subject.name = 'foo'
      expect(subject.name).to eql('foo')
    end
  end
end
