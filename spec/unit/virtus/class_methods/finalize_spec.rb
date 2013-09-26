require 'spec_helper'

describe Virtus, '.finalize' do
  it 'works' do
    class Person
      include Virtus.model

      attribute :articles, Array['Article']
    end

    class Article
      include Virtus.model

      attribute :person, 'Person'
    end

    Virtus.finalize

    expect(Person.attribute_set[:articles].member_type.primitive).to be(Article)
    expect(Article.attribute_set[:person].type.primitive).to be(Person)
  end
end
