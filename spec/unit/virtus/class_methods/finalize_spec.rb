require 'spec_helper'

describe Virtus, '.finalize' do
  before do
    module Examples
      class Person
        include Virtus.model(:finalize => false)

        attribute :name,     String
        attribute :articles, Array['Examples::Article']
        attribute :address,  :'Examples::Address'
      end

      class Article
        include Virtus.model(:finalize => false)

        attribute :posts, Hash['Examples::Person' => 'Examples::Post']
        attribute :person, :'Examples::Person'
      end

      class Post
        include Virtus.model

        attribute :title, String
      end

      class Address
        include Virtus.model

        attribute :street, String
      end
    end

    expect(Examples::Post.attribute_set[:title]).to be_finalized
    expect(Examples::Address.attribute_set[:street]).to be_finalized

    expect(Virtus::Builder.pending).not_to include(Examples::Post)
    expect(Virtus::Builder.pending).not_to include(Examples::Address)

    Virtus.finalize
  end

  it "sets attributes that don't require finalization" do
    expect(Examples::Person.attribute_set[:name]).to be_instance_of(Virtus::Attribute)
    expect(Examples::Person.attribute_set[:name].primitive).to be(String)
  end

  it 'it finalizes member type for a collection attribute' do
    expect(Examples::Person.attribute_set[:address].primitive).to be(Examples::Address)
  end

  it 'it finalizes key type for a hash attribute' do
    expect(Examples::Article.attribute_set[:posts].key_type.primitive).to be(Examples::Person)
  end

  it 'it finalizes value type for a hash attribute' do
    expect(Examples::Article.attribute_set[:posts].value_type.primitive).to be(Examples::Post)
  end

  it 'it finalizes type for an EV attribute' do
    expect(Examples::Article.attribute_set[:person].type.primitive).to be(Examples::Person)
  end

  it 'automatically resolves constant when it is already available' do
    expect(Examples::Article.attribute_set[:person].type.primitive).to be(Examples::Person)
  end
end
