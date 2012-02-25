require 'spec_helper'

describe "default values" do

  before do
    module Examples
      class Page
        include Virtus

        attribute :title,        String
        attribute :slug,         String,  :default => lambda { |post, attribute| post.title.downcase.gsub(' ', '-') }
        attribute :view_count,   Integer, :default => 0
        attribute :published,    Boolean, :default => false, :accessor => :private
        attribute :editor_title, String,  :default => :default_editor_title

        def default_editor_title
          published? ? title : "UNPUBLISHED: #{title}"
        end
      end

    end
  end

  subject { Examples::Page.new }

  specify 'without a default the value is nil' do
    subject.title.should be_nil
  end

  specify 'can be supplied with the :default option' do
    subject.view_count.should == 0
  end

  specify "you can pass a 'callable-object' to the :default option" do
    subject.title = 'Example Blog Post'
    subject.slug.should == 'example-blog-post'
  end

  specify 'you can set defaults for private attributes' do
    subject.title = 'Top Secret'
    subject.editor_title.should == 'UNPUBLISHED: Top Secret'
  end

end
