require 'spec_helper'

class ValueObjectTest
  include Subvirtus.value_object
  values do
    attribute :name,  String
    attribute :age,   Integer, default: 42
  end
end

describe ValueObjectTest do
  before do
    @test = ValueObjectTest.new
  end

  it 'has a working name attribute' do
    @test.name = 'subvirtus'
    expect( @test.name ).to eq( 'subvirtus' )
  end
  it 'has a working age attribute with default value' do
    expect( @test.age ).to eq( 42 )
  end
  it 'considers objects with different values to not be equal' do
    @test.name = 'subvirtus'
    @test2 = ValueObjectTest.new( { name: 'david', age: 43 } )
    expect( @test == @test2 ).to be_falsey
  end
  it 'considers objects with same values to be equal' do
    @test.name = 'david'
    @test.age  = 43
    @test2 = ValueObjectTest.new( { name: 'david', age: 43 } )
    expect( @test == @test2 ).to be_truthy
  end
end