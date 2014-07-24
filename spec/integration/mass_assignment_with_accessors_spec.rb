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
    expect(subject.category).to eq('Office')
    expect(subject.subcategory).to eq('Printers')
  end

  specify 'can be set with #attributes=' do
    subject.attributes = {:categories => ['Home', 'Furniture']}
    expect(subject.category).to eq('Home')
    expect(subject.subcategory).to eq('Furniture')
  end

  specify 'respects accessor visibility' do
    expect(subject.id).not_to eq(100)
  end
end
