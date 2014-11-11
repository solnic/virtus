require 'spec_helper'

class PlainIntegerTest
  include Virtus::Lite
  attribute :age, 	Bignum
end

describe PlainIntegerTest do
  before do
    @test = PlainIntegerTest.new
  end

  it 'returns an integer value given' do
    @test.age = 11
    expect( @test.age ).to eq( 11 )
  end
  it 'returns an integer when given an integer' do
    @test.age = 87
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns an integer when given a string' do
    @test.age = "42"
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns an integer representive of a given integer in a string' do
    @test.age = "42"
    expect( @test.age ).to eq( 42 )
  end
  it 'returns an integer when given an float' do
    @test.age = 42.7
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns an integer representive of a given float' do
    @test.age = 42.7
    expect( @test.age ).to eq( 42 )
  end
  it 'returns an integer when given a boolean' do
    @test.age = true
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns a 0 when given a false' do
    @test.age = false
    expect( @test.age ).to eq( 0 )
  end
  it 'returns a 1 when given a true' do
    @test.age = true
    expect( @test.age ).to eq( 1 )
  end
  it 'does not return an integer when given a nil' do
    @test.age = nil
    expect( @test.age.is_a? Integer ).to be_falsey
  end
  it 'returns nil when given a nil' do
    @test.age = nil
    expect( @test.age ).to eq( nil )
  end
  it 'returns nil when nothing is passed in' do
    expect( @test.age ).to eq( nil )
  end
end

class IntegerTestWithDefault
  include Virtus::Lite
  attribute :age, Bignum, default: 9
end

describe IntegerTestWithDefault do
  before do
    @test = IntegerTestWithDefault.new
  end

  it 'returns an integer value given' do
    @test.age = 11
    expect( @test.age ).to eq( 11 )
  end
  it 'returns an integer when given an integer' do
    @test.age = 87
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns an integer when given a string' do
    @test.age = "42"
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns an integer representive of a given integer in a string' do
    @test.age = "42"
    expect( @test.age ).to eq( 42 )
  end
  it 'returns an integer when given an float' do
    @test.age = 42.7
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns an integer representive of a given float' do
    @test.age = 42.7
    expect( @test.age ).to eq( 42 )
  end
  it 'returns an integer when given a boolean' do
    @test.age = true
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns a 0 when given a false' do
    @test.age = false
    expect( @test.age ).to eq( 0 )
  end
  it 'returns a 1 when given a true' do
    @test.age = true
    expect( @test.age ).to eq( 1 )
  end
  it 'returns an integer when given a nil' do
    @test.age = nil
    expect( @test.age.is_a? Integer ).to be_truthy
  end
  it 'returns the default when given a nil' do
    @test.age = nil
    expect( @test.age ).to eq( 9 )
  end
  it 'returns the default when nothing is passed in' do
    expect( @test.age ).to eq( 9 )
  end
end
