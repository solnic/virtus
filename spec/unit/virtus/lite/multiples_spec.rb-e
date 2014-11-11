require 'spec_helper'

class PlainMultiplesTest
  include Subvirtus
  attribute :name,  String
  attribute :age,   Integer
  attribute :here,  Boolean
  attribute :cash,  Float
end

describe PlainMultiplesTest do
  before do
    @test = PlainMultiplesTest.new
  end

  it 'returns nil initial values for multiple attributes' do
    expect( @test.name  ).to eq( nil )
    expect( @test.age   ).to eq( nil )
    expect( @test.here  ).to eq( nil )
    expect( @test.cash  ).to eq( nil )
  end
  it 'returns separate values for multiple given attributes' do
    @test.name  = 'david'
    @test.age   = 42
    @test.here  = true
    @test.cash  = 9.57

    expect( @test.name  ).to eq( 'david'  )
    expect( @test.age   ).to eq( 42       )
    expect( @test.here  ).to eq( true     )
    expect( @test.cash  ).to eq( 9.57     )
  end
end

class MultiplesTestWithDefaults
  include Subvirtus
  attribute :name,  String,   default: 'subvirtus'
  attribute :age,   Integer,  default: 43
  attribute :here,  Boolean,  default: true
  attribute :cash,  Float,    default: 9.99
end

describe MultiplesTestWithDefaults do
  before do
    @test = MultiplesTestWithDefaults.new
  end

  it 'returns separate initial values for multiple attributes' do
    expect( @test.name  ).to eq( 'subvirtus'  )
    expect( @test.age   ).to eq( 43           )
    expect( @test.here  ).to eq( true         )
    expect( @test.cash  ).to eq( 9.99         )
  end
  it 'returns separate values for multiple given attributes' do
    @test.name  = 'david'
    @test.age   = 42
    @test.here  = true
    @test.cash  = 9.57

    expect( @test.name  ).to eq( 'david'  )
    expect( @test.age   ).to eq( 42       )
    expect( @test.here  ).to eq( true     )
    expect( @test.cash  ).to eq( 9.57     )
  end
end