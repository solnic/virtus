require 'spec_helper'

class PlainStringTest
  include Subvirtus
  attribute :name, String
end

describe PlainStringTest do
  before do
    @test = PlainStringTest.new
  end

  it 'returns a string value given' do
    @test.name = 'david'
    expect( @test.name ).to eq( 'david' )
  end
  it 'returns a string when given a string' do
    @test.name = 'david'
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns a string when given an integer' do
    @test.name = 42
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns a string representive of a given integer' do
    @test.name = 42
    expect( @test.name ).to eq( '42' )
  end
  it 'returns a string when given an float' do
    @test.name = 42.7
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns a string representive of a given float' do
    @test.name = 42.7
    expect( @test.name ).to eq( '42.7' )
  end
  it 'returns a string when given a boolean' do
    @test.name = true
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns a "false" when given a false' do
    @test.name = false
    expect( @test.name ).to eq( 'false' )
  end
  it 'returns a "true" when given a true' do
    @test.name = true
    expect( @test.name ).to eq( 'true' )
  end
  it 'does not return a string when given a nil' do
    @test.name = nil
    expect( @test.name.is_a? String ).to be_falsey
  end
  it 'returns nil when given a nil' do
    @test.name = nil
    expect( @test.name ).to eq( nil )
  end
  it 'returns nil when nothing is passed in' do
    expect( @test.name ).to eq( nil )
  end
  it 'returns to_s when passed something random without a defined to_s' do
	class SomeClass; end
  	some_class = SomeClass.new
  	@test.name = some_class
    expect( @test.name ).to eq( some_class.to_s )
  end
  it 'returns to_s when passed something random with a defined to_s' do
	class SomeClass; def to_s; 'random'; end; end
  	some_class = SomeClass.new
  	@test.name = some_class
    expect( @test.name ).to eq( some_class.to_s )
  end
end

class StringTestWithDefault
  include Subvirtus
  attribute :name, String, default: 'subvirtus'
end

describe StringTestWithDefault do
  before do
    @test = StringTestWithDefault.new
  end

  it 'returns a string value given' do
    @test.name = 'david'
    expect( @test.name ).to eq( 'david' )
  end
  it 'returns a string when given a string' do
    @test.name = 'david'
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns a string when given an integer' do
    @test.name = 42
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns a string representive of a given integer' do
    @test.name = 42
    expect( @test.name ).to eq( '42' )
  end
  it 'returns a string when given an float' do
    @test.name = 42.7
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns a string representive of a given float' do
    @test.name = 42.7
    expect( @test.name ).to eq( '42.7' )
  end
  it 'returns a string when given a boolean' do
    @test.name = true
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns a "false" when given a false' do
    @test.name = false
    expect( @test.name ).to eq( 'false' )
  end
  it 'returns a "true" when given a true' do
    @test.name = true
    expect( @test.name ).to eq( 'true' )
  end
  it 'returns a string when given a nil' do
    @test.name = nil
    expect( @test.name.is_a? String ).to be_truthy
  end
  it 'returns the default when given a nil' do
    @test.name = nil
    expect( @test.name ).to eq( 'subvirtus' )
  end
  it 'returns the default when nothing is passed in' do
    expect( @test.name ).to eq( 'subvirtus' )
  end
  it 'returns to_s when passed something random without a defined to_s' do
	class SomeClass; end
  	some_class = SomeClass.new
  	@test.name = some_class
    expect( @test.name ).to eq( some_class.to_s )
  end
  it 'returns to_s when passed something random with a defined to_s' do
	class SomeClass; def to_s; 'random'; end; end
  	some_class = SomeClass.new
  	@test.name = some_class
    expect( @test.name ).to eq( some_class.to_s )
  end
end