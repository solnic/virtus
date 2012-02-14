require 'spec_helper'

describe "mass assignment with accessors" do

  before do
    module Examples
      class Product
        include Virtus

        attribute :id,          Integer
        attribute :category,    String
        attribute :subcategory, String

        def categories=(categories)
          self.category = categories.first
          self.subcategory = categories.last
        end

      private

        def _id=(value)
          self.id = value
        end
      end
    end
  end

  subject { Examples::Product.new(:categories => ['Office', 'Printers'], :_id => 100) }

  specify 'works uppon instantiation' do
    subject.category.should == 'Office'
    subject.subcategory.should == 'Printers'
  end

  specify 'can be set with #attributes=' do
    subject.attributes = {:categories => ['Home', 'Furniture']}
    subject.category.should == 'Home'
    subject.subcategory.should == 'Furniture'
  end

  specify 'respects accessor visibility' do
    subject.id.should_not == 100
  end
end
