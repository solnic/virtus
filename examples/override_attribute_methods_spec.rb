require './spec/spec_helper'

class Article
  include Virtus

  attribute :author, String

  def author
    super || '<unknown>'
  end

  def author=(name)
    super unless name == 'Brad'
  end

end

describe Article, 'override' do

  it 'Alice is an allowed author' do
    Article.new(:author => 'Alice').author.should == 'Alice'
  end

  it 'Brad isn not an allowed author' do
    Article.new(:author => 'Brad').author.should == '<unknown>'
  end

  context 'with author' do
    subject { Article.new(:author => 'John') }

    its(:author) { should == 'John' }
  end

  context 'without author' do
    subject { Article.new }

    its(:author) { should == '<unknown>' }
  end

end
