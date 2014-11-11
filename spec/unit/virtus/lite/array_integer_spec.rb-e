require 'spec_helper'

class PlainArrayIntegerTest
  include Subvirtus
  attribute :fish, Array[Integer]
end

describe PlainArrayIntegerTest do
  before do
    @test = PlainArrayIntegerTest.new
  end

  it 'returns array of integers when set to array of strings' do
    @test.fish = [ 'red', 'blue' ]
    expect( @test.fish ).to eq( [ 0, 0 ] )
  end
  it 'returns array of integers when set to array of integers' do
    @test.fish = [ 1, 2 ]
    expect( @test.fish ).to eq( [ 1, 2 ] )
  end
  it 'returns array of integers when set to array of booleans' do
    @test.fish = [ true, false ]
    expect( @test.fish ).to eq( [ 1, 0 ] )
  end
  it 'returns array of integers when set to array of floats' do
    @test.fish = [ 7.6, 23.5 ]
    expect( @test.fish ).to eq( [ 7, 23 ] )
  end
  it 'returns array of integers when set to a mixed array' do
    @test.fish = [ 'red', 42, false, 34.5, Integer ]
    expect( @test.fish ).to eq( [ 0, 42, 0, 34, 0 ] )
  end
end