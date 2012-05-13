require 'spec_helper'

describe 'Using Struct as an embedded value attribute' do
  before do
    module Examples
      Point = Struct.new(:x, :y)

      class Rectangle
        include Virtus

        attribute :top_left,     Point
        attribute :bottom_right, Point
      end
    end
  end

  subject do
    Examples::Rectangle.new(:top_left => [ 3, 5 ], :bottom_right => [ 8, 7 ])
  end

  specify 'initialize a struct object with correct attributes' do
    subject.top_left.x.should be(3)
    subject.top_left.y.should be(5)

    subject.bottom_right.x.should be(8)
    subject.bottom_right.y.should be(7)
  end
end
