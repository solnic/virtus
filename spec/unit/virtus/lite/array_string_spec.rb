require 'spec_helper'

class PlainArrayStringTest
  include Virtus::Lite
  attribute :fish, Array[String]
end

describe PlainArrayStringTest do
  before do
    @test = PlainArrayStringTest.new
  end

  it 'returns array of strings when set to array of strings' do
    @test.fish = [ 'red', 'blue' ]
    expect( @test.fish ).to eq( [ 'red', 'blue' ] )
  end
  it 'returns array of strings when set to array of integers' do
    @test.fish = [ 1, 2 ]
    expect( @test.fish ).to eq( [ '1', '2' ] )
  end
  it 'returns array of strings when set to array of booleans' do
    @test.fish = [ true, false ]
    expect( @test.fish ).to eq( [ 'true', 'false' ] )
  end
  it 'returns array of strings when set to array of floats' do
    @test.fish = [ 7.6, 23.5 ]
    expect( @test.fish ).to eq( [ '7.6', '23.5' ] )
  end
  it 'returns array of strings when set to a mixed array' do
    @test.fish = [ 'red', 42, false, 34.5, String ]
    expect( @test.fish ).to eq( [ 'red', '42', 'false', '34.5', 'String' ] )
  end
end
