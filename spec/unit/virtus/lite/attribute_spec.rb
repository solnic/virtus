require 'spec_helper'

describe 'include Virtus::Lite' do

  let :model do
    Class.new do
      include Virtus::Lite
    end
  end

  it 'responds to #attribute' do
    expect( model ).to respond_to( :attribute )
  end

  it 'responds to #attributes' do
    expect( model ).to respond_to( :attributes )
  end

  it 'responds to #set_attributes' do
    expect( model ).to respond_to( :set_attributes )
  end
end
