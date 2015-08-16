require 'spec_helper'

class PlainFloatTest
  include Subvirtus
  attribute :cash, Float
end

describe PlainFloatTest do
  before do
    @test = PlainFloatTest.new
  end

  it 'returns a float value given' do
    @test.cash = 11.89
    expect( @test.cash ).to eq( 11.89 )
  end
  it 'returns a float when given a float' do
    @test.cash = 87.2
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns a float when given a string' do
    @test.cash = "42.5"
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns a float representive of a given float in a string' do
    @test.cash = "42.5"
    expect( @test.cash ).to eq( 42.5 )
  end
  it 'returns a float when given an integer' do
    @test.cash = 42
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns a float representive of a given integer' do
    @test.cash = 42
    expect( @test.cash ).to eq( 42.0 )
  end
  it 'returns a float when given a boolean' do
    @test.cash = true
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns a 0.0 when given a false' do
    @test.cash = false
    expect( @test.cash ).to eq( 0.0 )
  end
  it 'returns a 1.0 when given a true' do
    @test.cash = true
    expect( @test.cash ).to eq( 1.0 )
  end
  it 'does not return a float when given a nil' do
    @test.cash = nil
    expect( @test.cash.is_a? Float ).to be_falsey
  end
  it 'returns nil when given a nil' do
    @test.cash = nil
    expect( @test.cash ).to eq( nil )
  end
  it 'returns nil when nothing is passed in' do
    expect( @test.cash ).to eq( nil )
  end
end

class FloatTestWithDefault
  include Subvirtus
  attribute :cash, Float, default: 9.57
end

describe FloatTestWithDefault do
  before do
    @test = FloatTestWithDefault.new
  end

  it 'returns a float value given' do
    @test.cash = 11.89
    expect( @test.cash ).to eq( 11.89 )
  end
  it 'returns a float when given a float' do
    @test.cash = 87.2
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns a float when given a string' do
    @test.cash = "42.5"
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns a float representive of a given float in a string' do
    @test.cash = "42.5"
    expect( @test.cash ).to eq( 42.5 )
  end
  it 'returns a float when given an integer' do
    @test.cash = 42
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns a float representive of a given integer' do
    @test.cash = 42
    expect( @test.cash ).to eq( 42.0 )
  end
  it 'returns a float when given a boolean' do
    @test.cash = true
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns a 0.0 when given a false' do
    @test.cash = false
    expect( @test.cash ).to eq( 0.0 )
  end
  it 'returns a 1.0 when given a true' do
    @test.cash = true
    expect( @test.cash ).to eq( 1.0 )
  end
  it 'returns a float when given a nil' do
    @test.cash = nil
    expect( @test.cash.is_a? Float ).to be_truthy
  end
  it 'returns the default when given a nil' do
    @test.cash = nil
    expect( @test.cash ).to eq( 9.57 )
  end
  it 'returns the default when nothing is passed in' do
    expect( @test.cash ).to eq( 9.57 )
  end
end