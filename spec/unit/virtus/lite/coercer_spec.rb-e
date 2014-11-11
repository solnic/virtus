require 'spec_helper'

class BooleanWriter
  def self.call( value )
    true
  end
end
class HashWriter
  def self.call( value )
    { a: 1, b: 2, z: 26 }
  end
end
class BooleanAsIntegerWriter
  def self.call( value )
    1
  end
end

class CoercerTest
  include Subvirtus
  attribute :here,   Boolean, coercer: BooleanWriter
  attribute :abcs,   Hash,    coercer: HashWriter
  attribute :number, Boolean, coercer: BooleanAsIntegerWriter
end

describe CoercerTest do
  before do
    @test = CoercerTest.new
  end

  it 'returns true when coercer sets to true' do
    expect( @test.here ).to eq( true )
  end

  it 'returns the return value of a coercer' do
    expect( @test.abcs ).to eq( { a: 1, b: 2, z: 26 } )
  end

  it 'does not convert a value returned by a coercer' do
    expect( @test.number ).to eq( 1 )
  end
end