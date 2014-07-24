require 'spec_helper'

describe "default values" do

  before do
    module Examples

      class Reference
        include Virtus::ValueObject

        attribute :ref, String
      end

      class Page
        include Virtus

        attribute :title,        String
        attribute :slug,         String,  :default => lambda { |post, attribute| post.title.downcase.gsub(' ', '-') }, :lazy => true
        attribute :view_count,   Integer, :default => 0
        attribute :published,    Boolean, :default => false, :accessor => :private
        attribute :editor_title, String,  :default => :default_editor_title, :lazy => true
        attribute :reference,    String,  :default => Reference.new
        attribute :revisions,    Array
        attribute :index,        Hash
        attribute :authors,      Set

        def default_editor_title
          published? ? title : "UNPUBLISHED: #{title}"
        end
      end

    end
  end

  subject { Examples::Page.new }

  specify 'without a default the value is nil' do
    expect(subject.title).to be_nil
  end

  specify 'can be supplied with the :default option' do
    expect(subject.view_count).to eq(0)
  end

  specify "you can pass a 'callable-object' to the :default option" do
    subject.title = 'Example Blog Post'
    expect(subject.slug).to eq('example-blog-post')
  end

  specify 'you can set defaults for private attributes' do
    subject.title = 'Top Secret'
    expect(subject.editor_title).to eq('UNPUBLISHED: Top Secret')
  end

  specify 'you can reset attribute to its default' do
    subject.view_count = 10
    expect do
      subject.reset_attribute(:view_count)
    end.to change { subject.view_count }.to(0)
  end

  context 'a ValueObject' do
    it 'does not duplicate the ValueObject' do
      page1 = Examples::Page.new
      page2 = Examples::Page.new
      expect(page1.reference).to equal(page2.reference)
    end
  end

  context 'an Array' do
    specify 'without a default the value is an empty Array' do
      expect(subject.revisions).to eql([])
    end
  end

  context 'a Hash' do
    specify 'without a default the value is an empty Hash' do
      expect(subject.index).to eql({})
    end
  end

  context 'a Set' do
    specify 'without a default the value is an empty Set' do
      expect(subject.authors).to eql(Set.new)
    end
  end
end
