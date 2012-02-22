require 'spec_helper'

describe "default values" do

  before do
    module Examples
      class Page
        include Virtus

        attribute :title,      String
        attribute :slug,       String,  :default => lambda { |post, attribute| post.title.downcase.gsub(' ', '-') }
        attribute :view_count, Integer, :default => 0
        attribute :published,  Boolean, :accessor => :private, :default => false
        attribute :editor_title, String, :default => lambda { |post, attribute|
          post.published? ? post.title : "UNPUBLISHED: #{post.title}"
        }
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
    pending "can't call private methods in a proc for the default value"
    subject.title = 'Top Secret'
    subject.editor_title.should == 'UNPUBLISHED: Top Secret'
  end

end
