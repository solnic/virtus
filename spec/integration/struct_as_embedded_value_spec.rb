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
    expect(subject.top_left.x).to be(3)
    expect(subject.top_left.y).to be(5)

    expect(subject.bottom_right.x).to be(8)
    expect(subject.bottom_right.y).to be(7)
  end
end
