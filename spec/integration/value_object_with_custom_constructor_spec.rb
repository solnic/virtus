require 'spec_helper'

describe "Defining a ValueObject with a custom constructor" do
  before do
    module Examples
      class Point
        include Virtus::ValueObject

        attribute :x, Integer
        attribute :y, Integer

        def initialize(attributes)
          if attributes.kind_of?(Array)
            self.x = attributes.first
            self.y = attributes.last
          else
            super
          end
        end
      end

      class Rectangle
        include Virtus

        attribute :top_left,     Point
        attribute :bottom_right, Point
      end
    end
  end

  subject do
    Examples::Rectangle.new(:top_left => [ 3, 4 ], :bottom_right => [ 5, 8 ])
  end

  specify "initialize a value object attribute with correct attributes" do
    subject.top_left.x.should be(3)
    subject.top_left.y.should be(4)

    subject.bottom_right.x.should be(5)
    subject.bottom_right.y.should be(8)
  end
end
