require 'spec_helper'

describe 'Inheritance' do
  before do
    module Examples
      class Base
        include Virtus.model
      end

      class First < Base
        attribute :id, Fixnum
        attribute :name, String, default: ->(first, _) { "Named: #{first.id}" }
        attribute :description, String
      end

      class Second < Base
        attribute :something, String
      end
    end
  end

  it 'inherits model from the base class' do
    expect(Examples::First.attribute_set.map(&:name)).to eql([:id, :name, :description])
    expect(Examples::Second.attribute_set.map(&:name)).to eql([:something])
  end

  it 'sets correct attributes on the descendant classes' do
    first = Examples::First.new(:id => 1, :description => 'hello world')

    expect(first.id).to be(1)
    expect(first.name).to eql('Named: 1')
    expect(first.description).to eql('hello world')

    second = Examples::Second.new

    expect(second.something).to be(nil)

    second.something = 'foo bar'

    expect(second.something).to eql('foo bar')
  end
end
