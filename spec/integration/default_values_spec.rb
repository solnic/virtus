require 'spec_helper'

describe "default values" do

  before do
    module Examples
      class Page
        include Virtus

        attribute :title,      String
        attribute :slug,       String,  :default => lambda { |post, attribute| post.title.downcase.gsub(' ', '-') }
        attribute :view_count, Integer, :default => 0
      end
    end
  end
  after { Examples.send(:remove_const, 'Page') }

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

end
