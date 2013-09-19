require 'spec_helper'

describe 'custom collection attributes' do
  let(:library) { Examples::Library.new }
  let(:books)   { library.books }

  before do
    module Examples end
    Examples.const_set 'BookCollection', book_collection_class

    module Examples
      class Book
        include Virtus

        attribute :title, String
      end

      class BookCollectionAttribute < Virtus::Attribute::Collection
        primitive BookCollection
      end

      class Library
        include Virtus

        attribute :books, BookCollection[Book]
      end
    end
  end

  after do
    [:BookCollectionAttribute, :BookCollection, :Book, :Library].each do |const|
      Examples.send(:remove_const, const)
    end
  end

  shared_examples_for 'a collection' do
    it 'can be used as Virtus attributes' do
      attribute = Examples::Library.attribute_set[:books]
      attribute.should be_kind_of(Examples::BookCollectionAttribute)
    end

    it 'defaults to an empty collection' do
      books_should_be_an_empty_collection
    end

    it 'coerces nil' do
      library.books = nil
      books_should_be_an_empty_collection
    end

    it 'coerces an empty array' do
      library.books = []
      books_should_be_an_empty_collection
    end

    it 'coerces an array of attribute hashes' do
      library.books = [{ :title => 'Foo' }]
      books.should be_kind_of(Examples::BookCollection)
    end

    it 'coerces its members' do
      library.books = [{ :title => 'Foo' }]
      books.count.should == 1
      books.first.should be_kind_of(Examples::Book)
    end

    def books_should_be_an_empty_collection
      books.should be_kind_of(Examples::BookCollection)
      books.count.should == 0
    end
  end

  context 'with an array subclass' do
    let(:book_collection_class) { Class.new(Array) }

    it_behaves_like 'a collection'
  end

  context 'with an enumerable' do
    require 'forwardable'

    let(:book_collection_class) {
      Class.new do
        extend Forwardable
        include Enumerable

        def_delegators :@array, :each, :<<

        def initialize(*args)
          @array = Array[*args]
        end

        def self.[](*args)
          new(*args)
        end
      end
    }

    it_behaves_like 'a collection'
  end
end
