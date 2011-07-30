require './spec/spec_helper'

class Page
  include Virtus

  attribute :title,      String
  attribute :slug,       String,  :default => lambda { |post, attribute| post.title.downcase.gsub(' ', '-') }
  attribute :view_count, Integer, :default => 0
end

describe Page do
  describe '#slug' do
    before { subject.title = 'Virtus Is Awesome' }

    its(:slug) { should eql('virtus-is-awesome') }
  end

  describe '#views_count' do
    its(:view_count) { should eql(0) }
  end
end
