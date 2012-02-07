require 'spec_helper'

describe 'overriding virtus behavior' do

  before do
    module Examples
      class Article
        include Virtus

        attribute :title, String

        def title
          super || '<unknown>'
        end

        def title=(name)
          super unless self.title == "can't be changed"
        end
      end
    end
  end

  describe 'overriding an attribute getter' do
    specify 'calls the defined getter' do
      Examples::Article.new.title.should == '<unknown>'
    end

    specify 'super can be used to access the getter defined by virtus' do
      Examples::Article.new(:title => 'example article').title.should == 'example article'
    end
  end

  describe 'overriding an attribute setter' do
    specify 'calls the defined setter' do
      article = Examples::Article.new(:title => "can't be changed")
      article.title = 'this will never be assigned'
      article.title.should == "can't be changed"
    end

    specify 'super can be used to access the setter defined by virtus' do
      article = Examples::Article.new(:title => 'example article')
      article.title = 'my new title'
      article.title.should == 'my new title'
    end
  end
end
